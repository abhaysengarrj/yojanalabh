import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repository/scheme_repository.dart';
import '../../data/update/scheme_updater.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _loading = true;
  String _statusMessage = 'डेटा लोड हो रहा है...';
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _fadeAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _initData();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
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
      _animController.stop();
      setState(() => _loading = false);
    } catch (_) {
      if (!mounted) return;
      _animController.stop();
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A237E),
                Color(0xFF283593),
                Color(0xFF3949AB),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeTransition(
                  opacity: _fadeAnim,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'योजनालाभ',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'सरकारी योजना पात्रता जांच',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 40),
                const SizedBox(
                  width: 28, height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _statusMessage,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return const ProfileScreen();
  }
}
