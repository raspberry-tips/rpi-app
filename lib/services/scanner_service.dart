import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:multicast_dns/multicast_dns.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../models/device.dart';

class ScannerService {
  static const List<int> _defaultPorts = [22, 80, 443, 8080];
  static const List<String> _piHostnamePrefixes = ['raspberrypi', 'raspberry'];
  static const List<String> _piMacPrefixes = [
    'b8:27:eb', // Raspberry Pi Foundation
    'dc:a6:32', // Raspberry Pi Trading Ltd
    'e4:5f:01', // Raspberry Pi Trading Ltd
    '28:cd:c1', // Raspberry Pi Trading Ltd
    '2c:cf:67', // Raspberry Pi Trading Ltd
    'd8:3a:dd', // Raspberry Pi Trading Ltd
    '88:a2:9e', // Raspberry Pi Trading Ltd
    '8c:1f:64', // Raspberry Pi Trading Ltd
    'f0:40:af', // Raspberry Pi Trading Ltd
  ];
  static const Duration _socketTimeout = Duration(milliseconds: 400);
  static const int _batchSize = 20;

  final _networkInfo = NetworkInfo();

  Future<String?> getWifiIP() => _networkInfo.getWifiIP();

  Stream<Device> scan({List<int>? ports}) async* {
    final checkPorts = ports ?? _defaultPorts;
    final wifiIP = await _networkInfo.getWifiIP();
    if (wifiIP == null) {
      throw Exception('Kein WLAN verbunden. Bitte mit einem Netzwerk verbinden.');
    }

    final subnet = _getSubnet(wifiIP);
    final seen = <String>{};

    // mDNS zuerst — schnelle Ergebnisse
    final mdnsDevices = await _scanMDNS();
    final initialArp = await _readArpTable();
    for (final device in mdnsDevices) {
      if (seen.add(device.ip)) {
        yield _enrichWithMac(device, initialArp);
      }
    }

    // mDNS: bekannte Pi-Hostnamen direkt auflösen → bestätigt Pi-IPs
    final confirmedIPs = await _resolveKnownPiHostnames();

    // Port-Scan aller 254 Hosts
    final allIPs = List.generate(254, (i) => '$subnet.${i + 1}');

    for (int i = 0; i < allIPs.length; i += _batchSize) {
      final batch = allIPs.sublist(i, min(i + _batchSize, allIPs.length));
      final results = await Future.wait(batch.map((ip) => _checkHost(ip, checkPorts)));

      // ARP-Tabelle nach jedem Batch lesen — Socket-Verbindungen füllen sie
      final arpTable = await _readArpTable();

      for (var device in results.whereType<Device>()) {
        if (seen.add(device.ip)) {
          // Per mDNS bestätigte Pi-IPs als confirmed markieren
          if (confirmedIPs.containsKey(device.ip)) {
            device = device.copyWith(
              hostname: device.hostname ?? confirmedIPs[device.ip],
              isPi: true,
              piConfirmed: true,
            );
          }
          yield _enrichWithMac(device, arpTable);
        }
      }
    }
  }

  Future<Map<String, String>> _resolveKnownPiHostnames() async {
    final candidates = [
      'raspberrypi.local',
      'pi.local',
      'raspberry.local',
      'raspberrypi2.local',
      'raspberrypi3.local',
      'raspberrypi4.local',
      'raspberrypi5.local',
    ];
    final entries = await Future.wait(
      candidates.map((host) async {
        try {
          final addresses = await InternetAddress.lookup(host)
              .timeout(const Duration(seconds: 2));
          return addresses
              .map((a) => MapEntry(a.address, host.replaceAll('.local', '')));
        } catch (_) {
          return <MapEntry<String, String>>[];
        }
      }),
    );
    return Map.fromEntries(entries.expand((e) => e));
  }

  Device _enrichWithMac(Device device, Map<String, String> arpTable) {
    final mac = arpTable[device.ip];
    if (mac == null) return device;
    final macIsPi = _isMacPi(mac);
    return device.copyWith(
      macAddress: mac,
      isPi: macIsPi || device.isPi,
      piConfirmed: macIsPi || device.piConfirmed,
    );
  }

  String _getSubnet(String ip) {
    final parts = ip.split('.');
    return '${parts[0]}.${parts[1]}.${parts[2]}';
  }

  Future<Map<String, String>> _readArpTable() async {
    final result = <String, String>{};
    try {
      final content = await File('/proc/net/arp').readAsString();
      for (final line in content.split('\n').skip(1)) {
        final parts = line.trim().split(RegExp(r'\s+'));
        if (parts.length >= 4) {
          final ip = parts[0];
          final mac = parts[3].toLowerCase();
          if (mac.length == 17 && mac != '00:00:00:00:00:00') {
            result[ip] = mac;
          }
        }
      }
    } catch (_) {}
    return result;
  }

  bool _isMacPi(String mac) {
    final lower = mac.toLowerCase();
    return _piMacPrefixes.any((prefix) => lower.startsWith(prefix));
  }

  Future<List<Device>> _scanMDNS() async {
    final results = <Device>[];
    try {
      final client = MDnsClient();
      await client.start();

      await for (final ptr in client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer('_ssh._tcp.local'),
        timeout: const Duration(seconds: 3),
      )) {
        await for (final ip4 in client.lookup<IPAddressResourceRecord>(
          ResourceRecordQuery.addressIPv4(ptr.domainName),
          timeout: const Duration(seconds: 2),
        )) {
          final hostname = ptr.domainName.replaceAll('.local', '');
          final isConfirmed = _piHostnamePrefixes.any(
            (p) => hostname.toLowerCase().contains(p),
          );
          results.add(Device(
            ip: ip4.address.address,
            hostname: hostname,
            openPorts: const [22],
            lastSeen: DateTime.now(),
            isPi: _isPiCandidate(hostname, const [22]),
            piConfirmed: isConfirmed,
          ));
        }
      }
      client.stop();
    } catch (_) {}
    return results;
  }

  Future<Device?> _checkHost(String ip, List<int> ports) async {
    final openPorts = <int>[];

    await Future.wait(
      ports.map((port) async {
        if (await _isPortOpen(ip, port)) openPorts.add(port);
      }),
    );

    if (openPorts.isEmpty) return null;

    String? hostname;
    try {
      // Reverse DNS via PTR lookup
      final reversed = await InternetAddress(ip)
          .reverse()
          .timeout(const Duration(seconds: 1));
      if (reversed.host != ip) hostname = reversed.host;
    } catch (_) {}
    // Fallback: mDNS .local auflösen
    if (hostname == null) {
      try {
        final parts = ip.split('.');
        final localName = '${parts[3]}.${parts[2]}.${parts[1]}.${parts[0]}.in-addr.arpa';
        final result = await InternetAddress.lookup(localName)
            .timeout(const Duration(milliseconds: 500));
        if (result.isNotEmpty && result.first.host != ip) {
          hostname = result.first.host;
        }
      } catch (_) {}
    }

    final h = hostname;
    final hostnameConfirmed = h != null &&
        _piHostnamePrefixes.any((p) => h.toLowerCase().contains(p));
    return Device(
      ip: ip,
      hostname: hostname,
      openPorts: openPorts,
      lastSeen: DateTime.now(),
      isPi: _isPiCandidate(hostname ?? '', openPorts),
      piConfirmed: hostnameConfirmed,
    );
  }

  Future<bool> _isPortOpen(String host, int port) async {
    try {
      final socket = await Socket.connect(host, port, timeout: _socketTimeout);
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  bool _isPiCandidate(String hostname, List<int> openPorts) {
    final hostnameMatch = _piHostnamePrefixes.any(
      (prefix) => hostname.toLowerCase().contains(prefix),
    );
    return hostnameMatch || openPorts.contains(22);
  }
}
