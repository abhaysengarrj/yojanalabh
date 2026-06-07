import 'package:flutter/material.dart';
import '../../models/scheme.dart';

Map<String, IconData> _categoryIcons = {
  'कृषि': Icons.agriculture,
  'आवास': Icons.home,
  'वित्तीय': Icons.account_balance,
  'महिला': Icons.woman,
  'पेंशन': Icons.elderly,
  'बालिका': Icons.child_care,
  'रोजगार': Icons.work,
  'शिक्षा': Icons.school,
  'स्वास्थ्य': Icons.local_hospital,
  'खाद्य': Icons.restaurant,
};

IconData _getCategoryIcon(String category) {
  return _categoryIcons[category] ?? Icons.miscellaneous_services;
}

Color _getCategoryColor(String category) {
  switch (category) {
    case 'कृषि':
      return Colors.green;
    case 'आवास':
      return Colors.indigo;
    case 'वित्तीय':
      return Colors.teal;
    case 'महिला':
      return Colors.pink;
    case 'पेंशन':
      return Colors.orange;
    case 'बालिका':
      return Colors.purple;
    case 'रोजगार':
      return Colors.blue;
    case 'शिक्षा':
      return Colors.amber;
    case 'स्वास्थ्य':
      return Colors.red;
    case 'खाद्य':
      return Colors.brown;
    default:
      return Colors.grey;
  }
}

class SchemeCard extends StatelessWidget {
  final Scheme scheme;
  final double? matchPercentage;
  final VoidCallback onTap;

  const SchemeCard({
    super.key,
    required this.scheme,
    this.matchPercentage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = _getCategoryColor(scheme.category);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: catColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_getCategoryIcon(scheme.category),
                    color: catColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scheme.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      scheme.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12.5, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.category_outlined,
                            size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 3),
                        Text(scheme.category,
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey.shade500)),
                        if (scheme.ministry.isNotEmpty) ...[
                          const SizedBox(width: 10),
                          Icon(Icons.account_balance,
                              size: 12, color: Colors.grey.shade500),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(scheme.ministry,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (matchPercentage != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: matchPercentage! >= 70
                        ? Colors.green.withValues(alpha: 0.12)
                        : matchPercentage! >= 50
                            ? Colors.orange.withValues(alpha: 0.12)
                            : Colors.grey.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${matchPercentage!.round()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: matchPercentage! >= 70
                          ? Colors.green.shade700
                          : matchPercentage! >= 50
                              ? Colors.orange.shade700
                              : Colors.grey,
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
