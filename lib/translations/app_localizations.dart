import 'package:flutter/material.dart';
import 'translations.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  String get languageCode => locale.languageCode;

  String tr(String key) {
    return Translations.get(key, languageCode);
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['hi', 'en', 'mr', 'bn', 'ta', 'te', 'gu', 'pa'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension TranslateX on BuildContext {
  String tr(String key) => AppLocalizations.of(this).tr(key);
}
