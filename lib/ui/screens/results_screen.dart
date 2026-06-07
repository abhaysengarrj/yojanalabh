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
    final partial = results.where((r) =>
        r.matchPercentage > 0 && r.matchPercentage < 50
    ).toList();

    return Scaffold(
      appBar: AppBar(title: Text('${eligible.length} योजनाएं मिलीं')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (eligible.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'आपके लिए उपयुक्त',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ...eligible.map((r) => _buildCard(context, r, true)),
          ],
          if (partial.isNotEmpty) ...[
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'आंशिक रूप से उपयुक्त',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ...partial.map((r) => _buildCard(context, r, false)),
          ],
          if (eligible.isEmpty && partial.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'कोई योजना नहीं मिली। कृपया अपनी जानकारी दोबारा जांचें।',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, EligibilityResult result, bool isEligible) {
    return SchemeCard(
      result: result,
      isEligible: isEligible,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailScreen(result: result),
          ),
        );
      },
    );
  }
}
