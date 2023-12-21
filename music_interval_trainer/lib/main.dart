import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'home_page.dart';

/*
 https://docs.flutter.dev/cookbook/design/themes
 https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization
 https://docs.flutter.dev/ui/layout/tutorial
 */

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
