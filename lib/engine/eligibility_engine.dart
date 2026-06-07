import '../models/scheme.dart';

class UserProfile {
  final int age;
  final String occupation;
  final String caste;
  final String gender;
  final String state;
  final double annualIncome;
  final double landAcres;
  final bool isBPL;
  final bool isMarried;
  final bool hasGirlChild;
  final bool hasDisability;

  UserProfile({
    required this.age,
    required this.occupation,
    required this.caste,
    required this.gender,
    required this.state,
    this.annualIncome = 0,
    this.landAcres = 0,
    this.isBPL = false,
    this.isMarried = false,
    this.hasGirlChild = false,
    this.hasDisability = false,
  });
}

class EligibilityResult {
  final Scheme scheme;
  final double matchPercentage;
  final List<String> matchedRules;
  final List<String> missedRules;

  EligibilityResult({
    required this.scheme,
    required this.matchPercentage,
    required this.matchedRules,
    required this.missedRules,
  });
}

class EligibilityEngine {
  static const double _weightAge = 15.0;
  static const double _weightIncome = 20.0;
  static const double _weightOccupation = 15.0;
  static const double _weightCaste = 10.0;
  static const double _weightGender = 10.0;
  static const double _weightState = 10.0;
  static const double _weightLand = 10.0;
  static const double _weightBPL = 5.0;
  static const double _weightMarried = 2.5;
  static const double _weightGirlChild = 2.5;

  double get _totalWeight {
    return _weightAge + _weightIncome + _weightOccupation +
        _weightCaste + _weightGender + _weightState + _weightLand +
        _weightBPL + _weightMarried + _weightGirlChild;
  }

  List<EligibilityResult> evaluate(
    UserProfile profile,
    List<Scheme> schemes,
  ) {
    final results = <EligibilityResult>[];
    for (final scheme in schemes) {
      results.add(_evaluateSingle(profile, scheme));
    }
    results.sort((a, b) => b.matchPercentage.compareTo(a.matchPercentage));
    return results;
  }

  EligibilityResult _evaluateSingle(UserProfile profile, Scheme scheme) {
    final rules = scheme.eligibility;
    final matchedRules = <String>[];
    final missedRules = <String>[];
    var earnedWeight = 0.0;

    void check(String name, double weight, bool passed) {
      if (passed) {
        earnedWeight += weight;
        matchedRules.add(name);
      } else {
        missedRules.add(name);
      }
    }

    check('आयु सीमा', _weightAge, _checkAge(rules, profile.age));
    check(
      'आय सीमा',
      _weightIncome,
      _checkIncome(rules, profile.annualIncome),
    );
    check(
      'व्यवसाय',
      _weightOccupation,
      _checkOccupation(rules, profile.occupation),
    );
    check('जाति', _weightCaste, _checkCaste(rules, profile.caste));
    check('लिंग', _weightGender, _checkGender(rules, profile.gender));
    check('राज्य', _weightState, _checkState(rules, profile.state));
    check('भूमि सीमा', _weightLand, _checkLand(rules, profile.landAcres));
    check('बीपीएल', _weightBPL, _checkBPL(rules, profile.isBPL));
    check('विवाहित', _weightMarried, _checkMarried(rules, profile.isMarried));
    check(
      'बालिका',
      _weightGirlChild,
      _checkGirlChild(rules, profile.hasGirlChild),
    );

    final percentage = (earnedWeight / _totalWeight * 100)
        .clamp(0.0, 100.0);

    return EligibilityResult(
      scheme: scheme,
      matchPercentage: percentage,
      matchedRules: matchedRules,
      missedRules: missedRules,
    );
  }

  bool _checkAge(EligibilityRules rules, int age) {
    if (rules.minAge == null && rules.maxAge == null) return true;
    if (rules.minAge != null && age < rules.minAge!) return false;
    if (rules.maxAge != null && age > rules.maxAge!) return false;
    return true;
  }

  bool _checkIncome(EligibilityRules rules, double income) {
    if (rules.maxAnnualIncome == null) return true;
    return income <= rules.maxAnnualIncome!;
  }

  bool _checkOccupation(EligibilityRules rules, String occupation) {
    if (rules.occupation == null) return true;
    return rules.occupation!.toLowerCase() == occupation.toLowerCase();
  }

  bool _checkCaste(EligibilityRules rules, String caste) {
    if (rules.caste == null) return true;
    return rules.caste!.toLowerCase() == caste.toLowerCase();
  }

  bool _checkGender(EligibilityRules rules, String gender) {
    if (rules.gender == null) return true;
    return rules.gender!.toLowerCase() == gender.toLowerCase();
  }

  bool _checkState(EligibilityRules rules, String state) {
    if (rules.state == null) return true;
    return rules.state!.toLowerCase() == state.toLowerCase();
  }

  bool _checkLand(EligibilityRules rules, double acres) {
    if (rules.maxLandAcres == null) return true;
    return acres <= rules.maxLandAcres!;
  }

  bool _checkBPL(EligibilityRules rules, bool isBPL) {
    if (rules.belowPovertyLine == null) return true;
    return isBPL == rules.belowPovertyLine;
  }

  bool _checkMarried(EligibilityRules rules, bool isMarried) {
    if (rules.married == null) return true;
    return isMarried == rules.married;
  }

  bool _checkGirlChild(EligibilityRules rules, bool hasGirlChild) {
    if (rules.hasGirlChild == null) return true;
    return hasGirlChild == rules.hasGirlChild;
  }
}
