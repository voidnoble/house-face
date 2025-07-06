import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');
  
  Locale get locale => _locale;
  
  // Use the supported locales from generated localizations
  static List<Locale> get supportedLocales => AppLocalizations.supportedLocales;
  
  // Language names for display
  static const Map<String, String> languageNames = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'ko': '한국어',
  };
  
  void setLocale(Locale locale) {
    if (!supportedLocales.contains(locale)) return;
    
    _locale = locale;
    notifyListeners();
  }
}
