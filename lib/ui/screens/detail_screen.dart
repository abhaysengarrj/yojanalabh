import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../engine/eligibility_engine.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('योजना विवरण'),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: _shareScheme),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.name, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    _buildMatchBadge(r.matchPercentage),
                    const SizedBox(height: 12),
                    Text(s.description),
                    if (s.ministry.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('मंत्रालय: ${s.ministry}',
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                    if (s.category.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text('श्रेणी: ${s.category}',
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('मिलान नियम', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...r.matchedRules.map((rule) => ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: Text(rule),
              dense: true,
            )),
            ...r.missedRules.map((rule) => ListTile(
              leading: const Icon(Icons.cancel, color: Colors.red),
              title: Text(rule),
              dense: true,
            )),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _openApplyLink,
                icon: _loading
                    ? const SizedBox(
                        height: 18, width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.open_in_new),
                label: Text(_loading ? 'खोल रहा है...' : 'आवेदन करें'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchBadge(double percentage) {
    Color color;
    if (percentage >= 70) {
      color = Colors.green;
    } else if (percentage >= 50) {
      color = Colors.orange;
    } else {
      color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${percentage.round()}% मिलान',
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
