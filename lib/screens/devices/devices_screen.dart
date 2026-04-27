import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../../models/device.dart';
import '../../services/device_storage.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  final _storage = DeviceStorage();
  List<Device> _devices = [];

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    final devices = await _storage.loadDevices();
    if (mounted) setState(() => _devices = devices);
  }

  Future<void> _renameDevice(Device device) async {
    final controller =
        TextEditingController(text: device.customName ?? device.displayName);
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        final l = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l.renameDialogTitle),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(labelText: l.renameFieldLabel),
            onSubmitted: (v) => Navigator.pop(context, v.trim()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l.buttonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: Text(l.buttonSave),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      await _storage.renameDevice(device.ip, result);
      _loadDevices();
    }
  }

  Future<void> _deleteDevice(Device device) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l.deleteDialogTitle),
          content: Text(l.deleteDialogMessage(device.displayName)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.buttonCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.buttonRemove),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _storage.deleteDevice(device.ip);
      _loadDevices();
    }
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.devicesTitle),
      ),
      body: _devices.isEmpty
          ? _buildEmptyState(l)
          : RefreshIndicator(
              onRefresh: _loadDevices,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _devices.length,
                itemBuilder: (context, index) => _DeviceTile(
                  device: _devices[index],
                  onRename: () => _renameDevice(_devices[index]),
                  onDelete: () => _deleteDevice(_devices[index]),
                  onBrowser: () => _openBrowser(_devices[index].ip),
                  onSSH: () => _openSSH(_devices[index].ip),
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.devices,
            size: 72,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            l.devicesEmptyMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  final Device device;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final VoidCallback onBrowser;
  final VoidCallback onSSH;

  const _DeviceTile({
    required this.device,
    required this.onRename,
    required this.onDelete,
    required this.onBrowser,
    required this.onSSH,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFC51A4A).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.developer_board,
                color: Color(0xFFC51A4A),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.displayName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    device.ip,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  Text(
                    l.deviceLastSeen(_formatDate(device.lastSeen)),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'browser':
                    onBrowser();
                  case 'ssh':
                    onSSH();
                  case 'rename':
                    onRename();
                  case 'delete':
                    onDelete();
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'browser',
                  child: ListTile(
                    leading: const Icon(Icons.open_in_browser),
                    title: Text(l.menuOpenBrowser),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'ssh',
                  child: ListTile(
                    leading: const Icon(Icons.terminal),
                    title: Text(l.menuOpenSsh),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'rename',
                  child: ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: Text(l.menuRename),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: const Icon(Icons.delete_outline),
                    title: Text(l.menuDelete),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
}
