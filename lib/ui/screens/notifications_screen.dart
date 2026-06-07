import 'package:flutter/material.dart';
import '../../translations/app_localizations.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    return Scaffold(
      appBar: AppBar(title: Text(tr('notifications'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Icon(Icons.notifications_none, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          Text(tr('noNotifications'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.update, color: Colors.blue),
              title: Text(tr('autoUpdate')),
              subtitle: Text(tr('autoUpdateSub')),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.wifi, color: Colors.green),
              title: Text(tr('offline')),
              subtitle: Text(tr('offlineSub')),
            ),
          ),
        ],
      ),
    );
  }
}
