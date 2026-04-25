import 'package:flutter/material.dart';

import '../../models/tool_item.dart';
import 'webview_screen.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tools'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: raspberryTipsTools.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) =>
            _ToolCard(tool: raspberryTipsTools[index]),
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final ToolItem tool;
  const _ToolCard({required this.tool});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            tool.icon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          tool.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(tool.description),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                WebViewScreen(title: tool.name, url: tool.url),
          ),
        ),
      ),
    );
  }
}
