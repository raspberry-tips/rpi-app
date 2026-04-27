import 'package:shared_preferences/shared_preferences.dart';

class ScanSettings {
  static const _key = 'scan_ports';
  static const List<int> defaultPorts = [22, 80, 443, 8080];
  static const Map<int, String> availablePorts = {
    22: 'SSH',
    80: 'HTTP',
    443: 'HTTPS',
    8080: 'HTTP Alt',
    5900: 'VNC',
    3000: 'Dev (3000)',
    8000: 'Dev (8000)',
    1883: 'MQTT',
    9090: 'Cockpit',
  };

  Future<List<int>> getSelectedPorts() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_key);
    if (stored == null) return List.of(defaultPorts);
    return stored.map(int.parse).toList();
  }

  Future<void> setSelectedPorts(List<int> ports) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ports.map((p) => p.toString()).toList());
  }
}
