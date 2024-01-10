import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info/package_info.dart';

import '../../common/environment/configuration.dart';
import '../../common/ui/widget_card_layout_ext.dart';

// https://chat.openai.com/share/451881ca-686c-4da7-a599-3f83e6b5b35f
// https://chat.openai.com/share/451881ca-686c-4da7-a599-3f83e6b5b35f

class WidgetAboutInformation extends StatefulWidget {
  const WidgetAboutInformation({super.key});

  @override
  WidgetAboutInformationState createState() => WidgetAboutInformationState();
}

class WidgetAboutInformationState extends State<WidgetAboutInformation> {
  final Configuration _configuration = Configuration();

  late String _appVersion = '?';

  @override
  void initState() {
    super.initState();

    _getAppVersion();
    _configuration.load(context);
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String supportEmail = _configuration.get("supportEmail");

    return WidgetCardLayoutExt(
      icon: const Icon(Icons.info_outline_rounded),
      title: AppLocalizations.of(context)!.viewAbout_Information_Title,
      iconAlignment: ListTileTitleAlignment.top,
      widgets: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.appTitle,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              AppLocalizations.of(context)!.viewAbout_Information_Version(_appVersion),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const Divider(height: 5),
            Text(
              AppLocalizations.of(context)!.viewAbout_Information_SupportEmail(supportEmail),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ],
    );
  }
}