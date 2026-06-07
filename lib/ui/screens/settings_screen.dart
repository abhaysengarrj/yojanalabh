import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../state/app_state.dart' as app_state;
import '../../data/repository/scheme_repository.dart';
import '../../engine/eligibility_engine.dart';
import '../../models/scheme.dart';
import '../../translations/app_localizations.dart';
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
    setState(() { _favoriteSchemes = favs; _loadingFavs = false; });
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.tr('clearData')),
        content: Text(context.tr('clearConfirm')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false),
              child: Text(context.tr('no'))),
          TextButton(onPressed: () => Navigator.pop(ctx, true),
              child: Text(context.tr('yes'))),
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
        SnackBar(content: Text(context.tr('dataCleared'))),
      );
    }
  }

  void _showLanguagePicker() {
    final appState = context.read<app_state.AppState>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final currentCode = appState.languageCode;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.tr('language'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...app_state.AppState.supportedLocales.map((locale) {
                final code = locale.languageCode;
                final name = app_state.AppState.localeNames[code] ?? code;
                final isSelected = currentCode == code;
                return ListTile(
                  leading: Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: isSelected ? Theme.of(context).colorScheme.primary : null),
                  title: Text(name),
                  trailing: isSelected
                      ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () {
                    appState.setLocale(locale);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<app_state.AppState>();
    final colorScheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [colorScheme.primary, colorScheme.secondary],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.settings, size: 32, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(tr('settings'),
                      style: const TextStyle(fontSize: 22,
                          fontWeight: FontWeight.bold, color: Colors.white)),
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
                              color: appState.isDark ? Colors.amber : Colors.grey.shade600),
                          title: Text(tr('darkMode')),
                          subtitle: Text(tr('darkModeSub')),
                          value: appState.isDark,
                          onChanged: (_) => appState.toggleDarkMode(),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.language),
                          title: Text(tr('language')),
                          subtitle: Text(
                            app_state.AppState.localeNames[appState.languageCode] ??
                                appState.languageCode,
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                          onTap: _showLanguagePicker,
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
                              Text(tr('favorites'),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                                  Icon(Icons.favorite_border, size: 36, color: Colors.grey.shade400),
                                  const SizedBox(height: 8),
                                  Text(tr('noFavorites'),
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
                                onTap: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => DetailScreen(
                                    result: EligibilityResult(
                                      scheme: scheme, matchPercentage: 0,
                                      matchedRules: [], missedRules: [],
                                    ),
                                  )),
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
                          title: Text(tr('clearData')),
                          subtitle: Text(tr('clearDataSub')),
                          onTap: _clearAllData,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.share),
                          title: Text(tr('shareApp')),
                          subtitle: Text(tr('shareAppSub')),
                          onTap: () {
                            Share.share('${tr('shareAppText')}https://github.com/abhaysengarrj/yojanalabh');
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.info_outline),
                          title: Text(tr('about')),
                          subtitle: Text('${tr('version')} 1.0.0'),
                          onTap: () => _showAbout(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('${tr('appName')} v1.0.0',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                  Text(tr('independentTool'),
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                      textAlign: TextAlign.center),
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
      applicationName: context.tr('appName'),
      applicationVersion: '1.0.0',
      applicationLegalese: context.tr('independentTool'),
      children: [Text(context.tr('aboutDesc'))],
    );
  }
}
