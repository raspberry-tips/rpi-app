class Device {
  final String ip;
  final String? hostname;
  final String? customName;
  final List<int> openPorts;
  final DateTime lastSeen;
  final bool isPi;
  final bool piConfirmed; // hostname oder MAC bestätigt
  final String? macAddress;

  const Device({
    required this.ip,
    this.hostname,
    this.customName,
    required this.openPorts,
    required this.lastSeen,
    required this.isPi,
    this.piConfirmed = false,
    this.macAddress,
  });

  String get displayName => customName ?? hostname ?? ip;

  Map<String, dynamic> toJson() => {
        'ip': ip,
        'hostname': hostname,
        'customName': customName,
        'openPorts': openPorts,
        'lastSeen': lastSeen.toIso8601String(),
        'isPi': isPi,
        'piConfirmed': piConfirmed,
        'macAddress': macAddress,
      };

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        ip: json['ip'] as String,
        hostname: json['hostname'] as String?,
        customName: json['customName'] as String?,
        openPorts: List<int>.from(json['openPorts'] as List),
        lastSeen: DateTime.parse(json['lastSeen'] as String),
        isPi: json['isPi'] as bool,
        piConfirmed: json['piConfirmed'] as bool? ?? false,
        macAddress: json['macAddress'] as String?,
      );

  Device copyWith({
    String? hostname,
    String? customName,
    String? macAddress,
    bool? isPi,
    bool? piConfirmed,
  }) =>
      Device(
        ip: ip,
        hostname: hostname ?? this.hostname,
        customName: customName ?? this.customName,
        openPorts: openPorts,
        lastSeen: lastSeen,
        isPi: isPi ?? this.isPi,
        piConfirmed: piConfirmed ?? this.piConfirmed,
        macAddress: macAddress ?? this.macAddress,
      );
}
