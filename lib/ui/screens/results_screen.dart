import 'package:flutter/material.dart';
import '../../engine/eligibility_engine.dart';
import '../widgets/scheme_card.dart';
import 'detail_screen.dart';

class ResultsScreen extends StatelessWidget {
  final List<EligibilityResult> results;
  const ResultsScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final eligible = results.where((r) => r.matchPercentage >= 50).toList();
    final partial =
        results.where((r) => r.matchPercentage > 0 && r.matchPercentage < 50).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${eligible.length} योजनाएं मिलीं'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: results.isEmpty ? 0 : eligible.length / results.length,
            backgroundColor: Colors.orange.withValues(alpha: 0.2),
          ),
        ),
      ),
      body: results.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text('कोई योजना नहीं मिली',
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('कृपया अपनी जानकारी दोबारा जांचें',
                      style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
              itemCount: eligible.length + partial.length,
              itemBuilder: (context, index) {
                EligibilityResult r;
                bool isEligible;
                if (index < eligible.length) {
                  r = eligible[index];
                  isEligible = true;
                } else {
                  r = partial[index - eligible.length];
                  isEligible = false;
                }
                final showHeader = index == 0 && eligible.isNotEmpty ||
                    (index == eligible.length && partial.isNotEmpty);
                return Column(
                  children: [
                    if (showHeader)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 4),
                        child: Row(
                          children: [
                            Icon(
                              isEligible
                                  ? Icons.check_circle
                                  : Icons.info_outline,
                              size: 18,
                              color: isEligible ? Colors.green : Colors.orange,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isEligible ? 'आपके लिए उपयुक्त' : 'आंशिक रूप से उपयुक्त',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isEligible ? Colors.green : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SchemeCard(
                      scheme: r.scheme,
                      matchPercentage: r.matchPercentage,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DetailScreen(result: r)),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
