import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repository/scheme_repository.dart';
import '../../data/update/scheme_updater.dart';
import '../screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
  String _statusMessage = 'डेटा लोड हो रहा है...';

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    if (!mounted) return;
    try {
      final repo = Provider.of<SchemeRepository>(context, listen: false);
      await repo.loadSeedData();

      final updater = SchemeUpdater();
      if (await updater.shouldCheckForUpdates()) {
        setState(() => _statusMessage = 'नई योजनाओं की जांच हो रही है...');
        final payload = await updater.checkForUpdates();
        if (payload != null && payload.schemes.isNotEmpty) {
          await repo.replaceAllSchemes(payload.schemes);
        }
        await updater.markCheckDone();
      }

      if (!mounted) return;
      setState(() => _loading = false);
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(_statusMessage, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    }

    return const ProfileScreen();
  }
}
