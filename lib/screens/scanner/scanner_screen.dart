import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/device.dart';
import '../../services/device_storage.dart';
import '../../services/scanner_service.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final _scanner = ScannerService();
  final _storage = DeviceStorage();

  bool _isScanning = false;
  String? _wifiIP;
  final _devices = <Device>[];
  String? _error;

  StreamSubscription<Device>? _scanSubscription;

  @override
  void initState() {
    super.initState();
    _loadWifiInfo();
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadWifiInfo() async {
    final ip = await _scanner.getWifiIP();
    if (mounted) setState(() => _wifiIP = ip);
  }

  Future<void> _startScan() async {
    if (_isScanning) return;
    setState(() {
      _isScanning = true;
      _devices.clear();
      _error = null;
    });

    try {
      _scanSubscription = _scanner.scan().listen(
        (device) {
          if (mounted) setState(() => _devices.add(device));
        },
        onError: (Object e) {
          if (mounted) {
            setState(() {
              _error = e.toString().replaceFirst('Exception: ', '');
              _isScanning = false;
            });
          }
        },
        onDone: () {
          if (mounted) setState(() => _isScanning = false);
        },
      );
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isScanning = false;
      });
    }
  }

  void _stopScan() {
    _scanSubscription?.cancel();
    setState(() => _isScanning = false);
  }

  Future<void> _openBrowser(String ip) async {
    final uri = Uri.parse('http://$ip');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openSSH(String ip) async {
    final uri = Uri.parse('ssh://pi@$ip');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('SSH-App benötigt'),
          content: const Text(
            'Für SSH wird eine SSH-App benötigt, z.B. Termius oder JuiceSSH.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _saveDevice(Device device) async {
    await _storage.saveDevice(device);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${device.displayName} gespeichert'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('IP Scanner'),
            Text(
              'raspberry.tips',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          if (_isScanning)
            IconButton(
              icon: const Icon(Icons.stop_circle_outlined),
              onPressed: _stopScan,
              tooltip: 'Scan stoppen',
            ),
        ],
      ),
      body: Column(
        children: [
          _NetworkInfoBar(wifiIP: _wifiIP),
          if (_isScanning) const LinearProgressIndicator(),
          if (_error != null) _ErrorBanner(message: _error!),
          _ScanButton(
            isScanning: _isScanning,
            hasResults: _devices.isNotEmpty,
            onPressed: _startScan,
          ),
          Expanded(
            child: _isScanning && _devices.isEmpty
                ? _buildScanningPlaceholder()
                : _devices.isEmpty
                    ? _buildEmptyState()
                    : _buildResultsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningPlaceholder() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Suche Raspberry Pis im Netzwerk…',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_find,
            size: 72,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Starte einen Scan um\nRaspberry Pis zu finden',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 12),
          const _HintBanner(),
        ],
      ),
    );
  }

  void _dismissDevice(Device device) {
    setState(() => _devices.remove(device));
  }

  Widget _buildResultsList() {
    final confirmedPis = _devices.where((d) => d.isPi && d.piConfirmed).toList();
    final possiblePis = _devices.where((d) => d.isPi && !d.piConfirmed).toList();
    final otherDevices = _devices.where((d) => !d.isPi).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      children: [
        if (confirmedPis.isNotEmpty) ...[
          _SectionHeader(label: 'Raspberry Pis (${confirmedPis.length})'),
          ...confirmedPis.map(
            (d) => _DeviceResultCard(
              device: d,
              onBrowser: () => _openBrowser(d.ip),
              onSSH: () => _openSSH(d.ip),
              onSave: () => _saveDevice(d),
              onDismiss: () => _dismissDevice(d),
            ),
          ),
        ],
        if (possiblePis.isNotEmpty) ...[
          _SectionHeader(label: 'Mögliche Pis (${possiblePis.length})'),
          ...possiblePis.map(
            (d) => _DeviceResultCard(
              device: d,
              onBrowser: () => _openBrowser(d.ip),
              onSSH: () => _openSSH(d.ip),
              onSave: () => _saveDevice(d),
              onDismiss: () => _dismissDevice(d),
            ),
          ),
        ],
        if (otherDevices.isNotEmpty) ...[
          _SectionHeader(label: 'Andere Geräte (${otherDevices.length})'),
          ...otherDevices.map(
            (d) => _DeviceResultCard(
              device: d,
              onBrowser: () => _openBrowser(d.ip),
              onSSH: () => _openSSH(d.ip),
              onSave: () => _saveDevice(d),
              onDismiss: () => _dismissDevice(d),
            ),
          ),
        ],
        if (_isScanning)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

class _HintBanner extends StatelessWidget {
  const _HintBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Dein Raspberry Pi muss im selben WLAN wie dieses Gerät sein.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkInfoBar extends StatelessWidget {
  final String? wifiIP;
  const _NetworkInfoBar({this.wifiIP});

  @override
  Widget build(BuildContext context) {
    if (wifiIP == null) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.wifi,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Text(
            'Deine IP: $wifiIP',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.errorContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 16,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  final bool isScanning;
  final bool hasResults;
  final VoidCallback onPressed;

  const _ScanButton({
    required this.isScanning,
    required this.hasResults,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: isScanning ? null : onPressed,
          icon: const Icon(Icons.wifi_find),
          label: Text(
            isScanning
                ? 'Scanne Netzwerk…'
                : hasResults
                    ? 'Erneut scannen'
                    : 'Netzwerk scannen',
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _DeviceResultCard extends StatelessWidget {
  final Device device;
  final VoidCallback onBrowser;
  final VoidCallback onSSH;
  final VoidCallback onSave;
  final VoidCallback onDismiss;

  const _DeviceResultCard({
    required this.device,
    required this.onBrowser,
    required this.onSSH,
    required this.onSave,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DeviceIcon(isPi: device.isPi, piConfirmed: device.piConfirmed),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              device.displayName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (device.isPi)
                            device.piConfirmed
                                ? const _PiConfirmedChip()
                                : const _PiPossibleChip(),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 16,
                              color: theme.colorScheme.outline,
                            ),
                            onPressed: onDismiss,
                            tooltip: 'Ausblenden',
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      _DeviceInfoRow(label: 'IP', value: device.ip),
                      if (device.hostname != null &&
                          device.hostname != device.ip)
                        _DeviceInfoRow(
                          label: 'Host',
                          value: device.hostname!,
                        ),
                      if (device.macAddress != null)
                        _DeviceInfoRow(
                          label: 'MAC',
                          value: device.macAddress!.toUpperCase(),
                          mono: true,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (device.openPorts.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: device.openPorts
                    .map((p) => _PortChip(port: p))
                    .toList(),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                if (device.openPorts.contains(80) ||
                    device.openPorts.contains(443) ||
                    device.openPorts.contains(8080))
                  _ActionButton(
                    icon: Icons.open_in_browser,
                    label: 'Browser',
                    onPressed: onBrowser,
                  ),
                if (device.openPorts.contains(22)) ...[
                  const SizedBox(width: 8),
                  _ActionButton(
                    icon: Icons.terminal,
                    label: 'SSH',
                    onPressed: onSSH,
                  ),
                ],
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.bookmark_add_outlined),
                  onPressed: onSave,
                  tooltip: 'Gerät speichern',
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceIcon extends StatelessWidget {
  final bool isPi;
  final bool piConfirmed;
  const _DeviceIcon({required this.isPi, this.piConfirmed = false});

  @override
  Widget build(BuildContext context) {
    final Color color;
    if (isPi && piConfirmed) {
      color = const Color(0xFFC51A4A);
    } else if (isPi) {
      color = Colors.orange;
    } else {
      color = Theme.of(context).colorScheme.outline;
    }
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isPi
            ? color.withValues(alpha: 0.12)
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        isPi ? Icons.developer_board : Icons.computer,
        color: color,
        size: 22,
      ),
    );
  }
}

class _PiConfirmedChip extends StatelessWidget {
  const _PiConfirmedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFC51A4A).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Raspberry Pi',
        style: TextStyle(
          color: Color(0xFFC51A4A),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PiPossibleChip extends StatelessWidget {
  const _PiPossibleChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Möglicher Pi?',
        style: TextStyle(
          color: Colors.orange,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DeviceInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool mono;

  const _DeviceInfoRow({
    required this.label,
    required this.value,
    this.mono = false,
  });

  @override
  Widget build(BuildContext context) {
    final outline = Theme.of(context).colorScheme.outline;
    return Row(
      children: [
        SizedBox(
          width: 36,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: outline,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: outline,
                  fontFamily: mono ? 'monospace' : null,
                ),
          ),
        ),
      ],
    );
  }
}

class _PortChip extends StatelessWidget {
  final int port;
  const _PortChip({required this.port});

  static const _portNames = {
    22: 'SSH',
    80: 'HTTP',
    443: 'HTTPS',
    8080: 'HTTP Alt',
    5900: 'VNC',
    8000: 'Dev',
    3000: 'Dev',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _portNames[port] ?? 'Port $port',
        style: TextStyle(
          fontSize: 11,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
