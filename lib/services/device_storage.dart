import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/device.dart';

class DeviceStorage {
  static const _key = 'saved_devices';

  Future<List<Device>> loadDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList
        .map((s) => Device.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveDevice(Device device) async {
    final prefs = await SharedPreferences.getInstance();
    final devices = await loadDevices();
    final index = devices.indexWhere((d) => d.ip == device.ip);
    if (index >= 0) {
      devices[index] = device;
    } else {
      devices.add(device);
    }
    await _persist(prefs, devices);
  }

  Future<void> deleteDevice(String ip) async {
    final prefs = await SharedPreferences.getInstance();
    final devices = await loadDevices();
    devices.removeWhere((d) => d.ip == ip);
    await _persist(prefs, devices);
  }

  Future<void> renameDevice(String ip, String customName) async {
    final prefs = await SharedPreferences.getInstance();
    final devices = await loadDevices();
    final index = devices.indexWhere((d) => d.ip == ip);
    if (index >= 0) {
      devices[index] = devices[index].copyWith(customName: customName);
      await _persist(prefs, devices);
    }
  }

  Future<void> _persist(SharedPreferences prefs, List<Device> devices) =>
      prefs.setStringList(
        _key,
        devices.map((d) => jsonEncode(d.toJson())).toList(),
      );
}
