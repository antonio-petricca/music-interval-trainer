import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:music_interval_trainer/tab_about_information.dart';
import 'package:music_interval_trainer/widget_card.dart';
import 'package:package_info/package_info.dart';

// https://chat.openai.com/share/451881ca-686c-4da7-a599-3f83e6b5b35f

class TabAboutInformationState extends State<TabAboutInformation> {
  late String appVersion = '?';

  @override
  void initState() {
    super.initState();
    getAppVersion();
  }

  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WidgetCard(
      AppLocalizations.of(context)!.tabAbout_About_Title,
      const Icon(Icons.info_outline_rounded),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.appTitle,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Text(
            AppLocalizations.of(context)!.tabAbout_About_Version(appVersion),
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const Divider(height: 5),
          Text(
            AppLocalizations.of(context)!.tabAbout_About_SupportEmail,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
