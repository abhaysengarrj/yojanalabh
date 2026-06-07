class EligibilityRules {
  final int? minAge;
  final int? maxAge;
  final double? maxAnnualIncome;
  final String? occupation;
  final String? caste;
  final String? gender;
  final String? state;
  final double? maxLandAcres;
  final bool? belowPovertyLine;
  final bool? married;
  final bool? hasGirlChild;
  final bool? hasDisability;

  EligibilityRules({
    this.minAge,
    this.maxAge,
    this.maxAnnualIncome,
    this.occupation,
    this.caste,
    this.gender,
    this.state,
    this.maxLandAcres,
    this.belowPovertyLine,
    this.married,
    this.hasGirlChild,
    this.hasDisability,
  });

  factory EligibilityRules.fromJson(Map<String, dynamic> json) {
    return EligibilityRules(
      minAge: json['minAge'] as int?,
      maxAge: json['maxAge'] as int?,
      maxAnnualIncome: (json['maxAnnualIncome'] as num?)?.toDouble(),
      occupation: json['occupation'] as String?,
      caste: json['caste'] as String?,
      gender: json['gender'] as String?,
      state: json['state'] as String?,
      maxLandAcres: (json['maxLandAcres'] as num?)?.toDouble(),
      belowPovertyLine: json['belowPovertyLine'] as bool?,
      married: json['married'] as bool?,
      hasGirlChild: json['hasGirlChild'] as bool?,
      hasDisability: json['hasDisability'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (minAge != null) 'minAge': minAge,
      if (maxAge != null) 'maxAge': maxAge,
      if (maxAnnualIncome != null) 'maxAnnualIncome': maxAnnualIncome,
      if (occupation != null) 'occupation': occupation,
      if (caste != null) 'caste': caste,
      if (gender != null) 'gender': gender,
      if (state != null) 'state': state,
      if (maxLandAcres != null) 'maxLandAcres': maxLandAcres,
      if (belowPovertyLine != null) 'belowPovertyLine': belowPovertyLine,
      if (married != null) 'married': married,
      if (hasGirlChild != null) 'hasGirlChild': hasGirlChild,
      if (hasDisability != null) 'hasDisability': hasDisability,
    };
  }
}

class Scheme {
  final int? id;
  final String name;
  final String description;
  final String ministry;
  final String applyLink;
  final String category;
  final EligibilityRules eligibility;
  final int version;

  Scheme({
    this.id,
    required this.name,
    required this.description,
    required this.ministry,
    required this.applyLink,
    required this.category,
    required this.eligibility,
    this.version = 1,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      id: json['id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      ministry: json['ministry'] as String? ?? '',
      applyLink: json['applyLink'] as String? ?? '',
      category: json['category'] as String? ?? 'अन्य',
      eligibility: EligibilityRules.fromJson(
        json['eligibility'] as Map<String, dynamic>? ?? {},
      ),
      version: json['version'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'ministry': ministry,
      'applyLink': applyLink,
      'category': category,
      'eligibility': eligibility.toJson(),
      'version': version,
    };
  }

  Map<String, dynamic> toDbMap() {
    return {
      'name': name,
      'description': description,
      'ministry': ministry,
      'applyLink': applyLink,
      'category': category,
      'eligibilityJson': eligibilityToJsonString(),
      'version': version,
    };
  }

  String eligibilityToJsonString() {
    return eligibility.toJson().toString();
  }

  Scheme copyWith({int? id}) {
    return Scheme(
      id: id ?? this.id,
      name: name,
      description: description,
      ministry: ministry,
      applyLink: applyLink,
      category: category,
      eligibility: eligibility,
      version: version,
    );
  }
}

class SchemeUpdatePayload {
  final int latestVersion;
  final List<Scheme> schemes;

  SchemeUpdatePayload({
    required this.latestVersion,
    required this.schemes,
  });

  factory SchemeUpdatePayload.fromJson(Map<String, dynamic> json) {
    return SchemeUpdatePayload(
      latestVersion: json['latestVersion'] as int,
      schemes: (json['schemes'] as List)
          .map((e) => Scheme.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
