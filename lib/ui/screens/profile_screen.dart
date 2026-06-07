import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repository/scheme_repository.dart';
import '../../engine/eligibility_engine.dart';
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
                  const Text(
                    'अपनी जानकारी दर्ज करें',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '30 सेकंड में जानें पात्र योजनाएं',
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
                    context,
                    Icons.person,
                    'व्यक्तिगत जानकारी',
                    [
                      _buildAgeSlider(context),
                      const SizedBox(height: 8),
                      _buildDropdown(context, 'व्यवसाय', _occupation, _occupations,
                          (v) => setState(() => _occupation = v), Icons.work),
                      _buildDropdown(context, 'जाति', _caste, _castes,
                          (v) => setState(() => _caste = v), Icons.group),
                      _buildDropdown(context, 'लिंग', _gender, _genders,
                          (v) => setState(() => _gender = v), Icons.wc),
                      _buildDropdown(context, 'राज्य', _state, _states,
                          (v) => setState(() => _state = v), Icons.location_city),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSectionCard(
                    context,
                    Icons.account_balance,
                    'आर्थिक जानकारी',
                    [
                      _buildIncomeSlider(context),
                      _buildLandSlider(context),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSectionCard(
                    context,
                    Icons.checklist,
                    'अन्य जानकारी',
                    [
                      _buildSwitch(context, 'बीपीएल कार्ड धारक', _isBPL,
                          (v) => setState(() => _isBPL = v), Icons.assignment),
                      _buildSwitch(context, 'विवाहित', _isMarried,
                          (v) => setState(() => _isMarried = v), Icons.favorite),
                      _buildSwitch(context, 'बालिका है', _hasGirlChild,
                          (v) => setState(() => _hasGirlChild = v), Icons.child_care),
                      _buildSwitch(context, 'दिव्यांग', _hasDisability,
                          (v) => setState(() => _hasDisability = v), Icons.accessible),
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
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search),
                                const SizedBox(width: 8),
                                const Text('योजनाएं जांचें'),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${_occupations.length + _castes.length + _genders.length + _states.length ~/ 2}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
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

  Widget _buildSectionCard(
      BuildContext context, IconData icon, String title, List<Widget> children) {
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
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
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
            const Text('आयु', style: TextStyle(fontSize: 15)),
            Text('$_age वर्ष',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).colorScheme.primary,
            thumbColor: Theme.of(context).colorScheme.primary,
            overlayColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
          ),
          child: Slider(
            value: _age.toDouble(),
            min: 1, max: 100, divisions: 99,
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
            const Text('वार्षिक आय', style: TextStyle(fontSize: 15)),
            Text(val,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).colorScheme.primary,
            thumbColor: Theme.of(context).colorScheme.primary,
            overlayColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
          ),
          child: Slider(
            value: _income,
            min: 0, max: 2500000, divisions: 250,
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
            const Text('कृषि भूमि', style: TextStyle(fontSize: 15)),
            Text('$_land एकड़',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).colorScheme.primary,
            thumbColor: Theme.of(context).colorScheme.primary,
            overlayColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
          ),
          child: Slider(
            value: _land,
            min: 0, max: 20, divisions: 40,
            label: '$_land एकड़',
            onChanged: (v) => setState(() => _land = v),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(BuildContext context, String label, String value,
      List<String> items, ValueChanged<String> onChanged, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }

  Widget _buildSwitch(BuildContext context, String label, bool value,
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
          value: value,
          onChanged: onChanged,
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultsScreen(results: results),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कुछ गलत हो गया। कृपया पुनः प्रयास करें।')),
      );
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }
}
