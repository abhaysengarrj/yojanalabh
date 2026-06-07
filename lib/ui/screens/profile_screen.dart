import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repository/scheme_repository.dart';
import '../../engine/eligibility_engine.dart';
import '../screens/results_screen.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('आपकी जानकारी')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAgeSlider(),
            const SizedBox(height: 16),
            _buildDropdown('व्यवसाय', _occupation, _occupations, (v) {
              setState(() => _occupation = v);
            }),
            const SizedBox(height: 16),
            _buildDropdown('जाति', _caste, _castes, (v) {
              setState(() => _caste = v);
            }),
            const SizedBox(height: 16),
            _buildDropdown('लिंग', _gender, _genders, (v) {
              setState(() => _gender = v);
            }),
            const SizedBox(height: 16),
            _buildDropdown('राज्य', _state, _states, (v) {
              setState(() => _state = v);
            }),
            const SizedBox(height: 16),
            _buildIncomeSlider(),
            const SizedBox(height: 16),
            _buildLandSlider(),
            const SizedBox(height: 16),
            _buildSwitch('बीपीएल कार्ड धारक', _isBPL, (v) {
              setState(() => _isBPL = v);
            }),
            _buildSwitch('विवाहित', _isMarried, (v) {
              setState(() => _isMarried = v);
            }),
            _buildSwitch('बालिका है', _hasGirlChild, (v) {
              setState(() => _hasGirlChild = v);
            }),
            _buildSwitch('दिव्यांग', _hasDisability, (v) {
              setState(() => _hasDisability = v);
            }),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _checking ? null : _checkEligibility,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: _checking
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('जांचें'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('आयु: $_age वर्ष', style: const TextStyle(fontSize: 16)),
        Slider(
          value: _age.toDouble(),
          min: 1, max: 100, divisions: 99,
          label: '$_age',
          onChanged: (v) => setState(() => _age = v.round()),
        ),
      ],
    );
  }

  Widget _buildIncomeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('वार्षिक आय: ₹${_income.toInt()}', style: const TextStyle(fontSize: 16)),
        Slider(
          value: _income,
          min: 0, max: 2500000,
          divisions: 250,
          label: '₹${_income.toInt()}',
          onChanged: (v) => setState(() => _income = v),
        ),
      ],
    );
  }

  Widget _buildLandSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('कृषि भूमि: $_land एकड़', style: const TextStyle(fontSize: 16)),
        Slider(
          value: _land,
          min: 0, max: 20,
          divisions: 40,
          label: '$_land एकड़',
          onChanged: (v) => setState(() => _land = v),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }

  Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
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
