import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return PopupMenuButton<Locale>(
          icon: const Icon(Icons.language),
          tooltip: AppLocalizations.of(context)!.language,
          onSelected: (Locale locale) {
            localeProvider.setLocale(locale);
          },
          itemBuilder: (BuildContext context) {
            return LocaleProvider.supportedLocales.map((Locale locale) {
              return PopupMenuItem<Locale>(
                value: locale,
                child: Row(
                  children: [
                    Text(LocaleProvider.languageNames[locale.languageCode] ?? locale.languageCode),
                    if (localeProvider.locale == locale)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.check, size: 16),
                      ),
                  ],
                ),
              );
            }).toList();
          },
        );
      },
    );
  }
}
