import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../engine/eligibility_engine.dart';
import '../../state/app_state.dart' as app_state;

class DetailScreen extends StatefulWidget {
  final EligibilityResult result;
  const DetailScreen({super.key, required this.result});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _loading = false;

  Future<void> _openApplyLink() async {
    final link = widget.result.scheme.applyLink;
    if (link.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('आवेदन लिंक उपलब्ध नहीं है')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final uri = Uri.parse(link);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('लिंक खोलने में असमर्थ')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _shareScheme() {
    final s = widget.result.scheme;
    Share.share(
      '${s.name}\n\n${s.description}\n\nआवेदन: ${s.applyLink}\n\nयोजनालाभ ऐप के माध्यम से',
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.result.scheme;
    final r = widget.result;
    final appState = context.watch<app_state.AppState>();
    final isFav = s.id != null ? appState.isFavorite(s.id!) : false;
    final colorScheme = Theme.of(context).colorScheme;
    final matchColor = r.matchPercentage >= 70
        ? Colors.green
        : r.matchPercentage >= 50
            ? Colors.orange
            : Colors.grey;

    return Scaffold(
      appBar: AppBar(
        title: const Text('योजना विवरण'),
        actions: [
          if (s.id != null)
            IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : null,
              ),
              onPressed: () => appState.toggleFavorite(s.id!),
            ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareScheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 90,
                            width: 90,
                            child: CircularProgressIndicator(
                              value: r.matchPercentage / 100,
                              strokeWidth: 8,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation(matchColor),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${r.matchPercentage.round()}%',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: matchColor,
                                ),
                              ),
                              Text('मिलान',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      s.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 12),
                    if (s.ministry.isNotEmpty || s.category.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          if (s.ministry.isNotEmpty)
                            _buildChip(context, Icons.account_balance,
                                s.ministry, colorScheme.primary),
                          if (s.category.isNotEmpty)
                            _buildChip(context, Icons.label,
                                s.category, colorScheme.secondary),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('मिलान नियम',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    if (r.matchedRules.isNotEmpty) ...[
                      const Text('पूर्ण:', style: TextStyle(color: Colors.green)),
                      ...r.matchedRules.map((rule) => Padding(
                            padding: const EdgeInsets.only(left: 8, top: 4),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle,
                                    size: 18, color: Colors.green.shade400),
                                const SizedBox(width: 8),
                                Text(rule),
                              ],
                            ),
                          )),
                    ],
                    if (r.missedRules.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text('अपूर्ण:',
                          style: TextStyle(color: Colors.red)),
                      ...r.missedRules.map((rule) => Padding(
                            padding: const EdgeInsets.only(left: 8, top: 4),
                            child: Row(
                              children: [
                                Icon(Icons.cancel,
                                    size: 18, color: Colors.red.shade300),
                                const SizedBox(width: 8),
                                Text(rule),
                              ],
                            ),
                          )),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _openApplyLink,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                icon: _loading
                    ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.open_in_new),
                label: Text(_loading ? 'खोल रहा है...' : 'आवेदन करें'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(
      BuildContext context, IconData icon, String text, Color color) {
    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(text, style: TextStyle(fontSize: 12, color: color)),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
