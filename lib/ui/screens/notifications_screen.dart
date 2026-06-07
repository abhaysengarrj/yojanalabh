import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('सूचनाएं')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Icon(Icons.notifications_none,
              size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          const Text('नई योजनाएं जुड़ने पर सूचित किया जाएगा',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.update, color: Colors.blue),
              title: const Text('स्वचालित अपडेट'),
              subtitle: const Text('हर हफ्ते नई सरकारी योजनाएं अपने आप आ जाती हैं'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.wifi, color: Colors.green),
              title: const Text('ऑफलाइन काम करता है'),
              subtitle: const Text('एक बार डाउनलोड करने के बाद इंटरनेट की जरूरत नहीं'),
            ),
          ),
        ],
      ),
    );
  }
}
