import 'package:flutter/material.dart';
import '../../engine/eligibility_engine.dart';

class SchemeCard extends StatelessWidget {
  final EligibilityResult result;
  final bool isEligible;
  final VoidCallback onTap;

  const SchemeCard({
    super.key,
    required this.result,
    required this.isEligible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = result.scheme;
    final percentage = result.matchPercentage.round();

    Color badgeColor;
    if (percentage >= 70) {
      badgeColor = Colors.green;
    } else if (percentage >= 50) {
      badgeColor = Colors.orange;
    } else {
      badgeColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (s.ministry.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        s.ministry,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$percentage%',
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
