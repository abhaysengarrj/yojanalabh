import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../state/app_state.dart' as app_state;
import '../../data/repository/scheme_repository.dart';
import '../../engine/eligibility_engine.dart';
import '../../models/scheme.dart';
import '../widgets/scheme_card.dart';
import 'detail_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<Scheme> _favoriteSchemes = [];
  bool _loadingFavs = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final appState = context.read<app_state.AppState>();
    final repo = Provider.of<SchemeRepository>(context, listen: false);
    final allSchemes = await repo.getAllSchemes();
    final favs = allSchemes.where((s) => appState.isFavorite(s.id ?? -1)).toList();
    if (!mounted) return;
    setState(() {
      _favoriteSchemes = favs;
      _loadingFavs = false;
    });
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('डेटा साफ़ करें'),
        content: const Text('सभी सेव की गई जानकारी और पसंदीदा हटा दें?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('नहीं')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('हां')),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      final repo = Provider.of<SchemeRepository>(context, listen: false);
      await repo.replaceAllSchemes([]);
      await repo.loadSeedData();
      if (!mounted) return;
      setState(() => _favoriteSchemes = []);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('डेटा साफ़ कर दिया गया')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<app_state.AppState>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary,
                    colorScheme.secondary,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.settings, size: 32, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'सेटिंग्स',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: Column(
                      children: [
                        SwitchListTile(
                          secondary: Icon(Icons.dark_mode,
                              color: appState.isDark
                                  ? Colors.amber
                                  : Colors.grey.shade600),
                          title: const Text('डार्क मोड'),
                          subtitle: const Text('रात में आंखों की सुरक्षा'),
                          value: appState.isDark,
                          onChanged: (_) => appState.toggleDarkMode(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Row(
                            children: [
                              Icon(Icons.favorite, size: 20, color: Colors.red),
                              const SizedBox(width: 8),
                              const Text('पसंदीदा योजनाएं',
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        if (_loadingFavs)
                          const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (_favoriteSchemes.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.favorite_border,
                                      size: 36, color: Colors.grey.shade400),
                                  const SizedBox(height: 8),
                                  Text('कोई पसंदीदा नहीं',
                                      style: TextStyle(color: Colors.grey.shade500)),
                                ],
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                            itemCount: _favoriteSchemes.length,
                            itemBuilder: (context, index) {
                              final scheme = _favoriteSchemes[index];
                              return SchemeCard(
                                scheme: scheme,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailScreen(
                                      result: EligibilityResult(
                                        scheme: scheme,
                                        matchPercentage: 0,
                                        matchedRules: [],
                                        missedRules: [],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.delete_outline),
                          title: const Text('डेटा साफ़ करें'),
                          subtitle: const Text('सारी जानकारी रीसेट करें'),
                          onTap: _clearAllData,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.share),
                          title: const Text('ऐप शेयर करें'),
                          subtitle: const Text('अपने दोस्तों को बताएं'),
                          onTap: () {
                            Share.share(
                              'योजनालाभ ऐप डाउनलोड करें और जानें कौन सी सरकारी योजना आपके लिए है!\n\nhttps://github.com/abhaysengarrj/yojanalabh',
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: const Text('ऐप के बारे में'),
                          subtitle: const Text('संस्करण 1.0.0'),
                          onTap: () => _showAbout(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'योजनालाभ v1.0.0',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                  Text(
                    'एक स्वतंत्र टूल • किसी सरकारी विभाग से संबद्ध नहीं',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'योजनालाभ',
      applicationVersion: '1.0.0',
      applicationLegalese: 'एक स्वतंत्र टूल • किसी सरकारी विभाग से संबद्ध नहीं',
      children: [
        const Text('सरकारी योजनाओं की पात्रता जांचने के लिए मुफ्त हिंदी ऐप।'),
      ],
    );
  }
}
