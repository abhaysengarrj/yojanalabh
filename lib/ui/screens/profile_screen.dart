import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repository/scheme_repository.dart';
import '../../engine/eligibility_engine.dart';
import '../../translations/app_localizations.dart';
import 'results_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _age = 25;
  String _occupation = 'किसान';
  String _caste = 'सामान्य';
  String _gender = 'पुरुष';
  String _state = 'उत्तर प्रदेश';
  double _income = 0;
  double _land = 0;
  bool _isBPL = false;
  bool _isMarried = false;
  bool _hasGirlChild = false;
  bool _hasDisability = false;
  bool _checking = false;

  final List<String> _occupations = [
    'किसान', 'मजदूर', 'सरकारी कर्मचारी',
    'निजी नौकरी', 'व्यवसायी', 'पेशेवर',
    'बेरोजगार', 'गृहिणी', 'छात्र', 'अन्य',
  ];
  final List<String> _castes = [
    'सामान्य', 'ओबीसी', 'एससी', 'एसटी', 'ईडब्ल्यूएस',
  ];
  final List<String> _genders = ['पुरुष', 'महिला', 'अन्य'];
  final List<String> _states = [
    'आंध्र प्रदेश', 'अरुणाचल प्रदेश', 'असम', 'बिहार',
    'छत्तीसगढ़', 'गोवा', 'गुजरात', 'हरियाणा',
    'हिमाचल प्रदेश', 'झारखंड', 'कर्नाटक', 'केरल',
    'मध्य प्रदेश', 'महाराष्ट्र', 'मणिपुर', 'मेघालय',
    'मिजोरम', 'नागालैंड', 'ओडिशा', 'पंजाब',
    'राजस्थान', 'सिक्किम', 'तमिल नाडु', 'तेलंगाना',
    'त्रिपुरा', 'उत्तर प्रदेश', 'उत्तराखंड', 'पश्चिम बंगाल',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = context.tr;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withValues(alpha: 0.8),
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
                    child: const Icon(Icons.person_outline, size: 36, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tr('enterDetails'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tr('subtitle'),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionCard(
                    Icons.person, tr('personalInfo'),
                    [_buildAgeSlider(context), const SizedBox(height: 8),
                      _buildDropdown(tr('occupation'), _occupation, _occupations,
                          (v) => setState(() => _occupation = v), Icons.work),
                      _buildDropdown(tr('caste'), _caste, _castes,
                          (v) => setState(() => _caste = v), Icons.group),
                      _buildDropdown(tr('gender'), _gender, _genders,
                          (v) => setState(() => _gender = v), Icons.wc),
                      _buildDropdown(tr('state'), _state, _states,
                          (v) => setState(() => _state = v), Icons.location_city),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSectionCard(
                    Icons.account_balance, tr('financialInfo'),
                    [_buildIncomeSlider(context), _buildLandSlider(context)],
                  ),
                  const SizedBox(height: 12),
                  _buildSectionCard(
                    Icons.checklist, tr('otherInfo'),
                    [_buildSwitch(tr('bpl'), _isBPL, (v) => setState(() => _isBPL = v), Icons.assignment),
                      _buildSwitch(tr('married'), _isMarried, (v) => setState(() => _isMarried = v), Icons.favorite),
                      _buildSwitch(tr('hasGirlChild'), _hasGirlChild, (v) => setState(() => _hasGirlChild = v), Icons.child_care),
                      _buildSwitch(tr('hasDisability'), _hasDisability, (v) => setState(() => _hasDisability = v), Icons.accessible),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _checking ? null : _checkEligibility,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      child: _checking
                          ? const SizedBox(
                              height: 24, width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5, color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search), const SizedBox(width: 8),
                                Text(tr('checkSchemes')),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(IconData icon, String title, List<Widget> children) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12), ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildAgeSlider(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.tr('age'), style: const TextStyle(fontSize: 15)),
            Text('$_age ${context.tr('years')}',
                style: TextStyle(fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).colorScheme.primary,
            thumbColor: Theme.of(context).colorScheme.primary,
            overlayColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
          ),
          child: Slider(
            value: _age.toDouble(), min: 1, max: 100, divisions: 99,
            label: '$_age',
            onChanged: (v) => setState(() => _age = v.round()),
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeSlider(BuildContext context) {
    final val = _income >= 100000
        ? '₹${(_income / 100000).toStringAsFixed(1)} लाख'
        : '₹${_income.toInt()}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.tr('annualIncome'), style: const TextStyle(fontSize: 15)),
            Text(val, style: TextStyle(fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).colorScheme.primary,
            thumbColor: Theme.of(context).colorScheme.primary,
            overlayColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
          ),
          child: Slider(
            value: _income, min: 0, max: 2500000, divisions: 250,
            label: '₹${_income.toInt()}',
            onChanged: (v) => setState(() => _income = v),
          ),
        ),
      ],
    );
  }

  Widget _buildLandSlider(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.tr('land'), style: const TextStyle(fontSize: 15)),
            Text('$_land ${context.tr('acres')}',
                style: TextStyle(fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).colorScheme.primary,
            thumbColor: Theme.of(context).colorScheme.primary,
            overlayColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
          ),
          child: Slider(
            value: _land, min: 0, max: 20, divisions: 40,
            label: '$_land ${context.tr('acres')}',
            onChanged: (v) => setState(() => _land = v),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      ValueChanged<String> onChanged, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) { if (v != null) onChanged(v); },
      ),
    );
  }

  Widget _buildSwitch(String label, bool value,
      ValueChanged<bool> onChanged, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SwitchListTile(
          secondary: Icon(icon, size: 20),
          title: Text(label, style: const TextStyle(fontSize: 15)),
          value: value, onChanged: onChanged,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Future<void> _checkEligibility() async {
    setState(() => _checking = true);
    try {
      final repo = Provider.of<SchemeRepository>(context, listen: false);
      final schemes = await repo.getAllSchemes();
      final engine = EligibilityEngine();
      final profile = UserProfile(
        age: _age, occupation: _occupation, caste: _caste,
        gender: _gender, state: _state, annualIncome: _income,
        landAcres: _land, isBPL: _isBPL, isMarried: _isMarried,
        hasGirlChild: _hasGirlChild, hasDisability: _hasDisability,
      );
      final results = engine.evaluate(profile, schemes);
      if (!mounted) return;
      Navigator.push(context,
        MaterialPageRoute(builder: (_) => ResultsScreen(results: results)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('error'))),
      );
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }
}
