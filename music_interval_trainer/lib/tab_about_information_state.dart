import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/tab_about_information.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/widget_card_layout.dart';
import 'package:package_info/package_info.dart';

// https://chat.openai.com/share/451881ca-686c-4da7-a599-3f83e6b5b35f

class TabAboutInformationState extends State<TabAboutInformation> {
  late String _appVersion = '?';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WidgetCardLayout(
      AppLocalizations.of(context)!.tabAbout_Information_Title,
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
            AppLocalizations.of(context)!.tabAbout_Information_Version(_appVersion), //TODO Into config.json
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const Divider(height: 5),
          Text(
            AppLocalizations.of(context)!.tabAbout_Information_SupportEmail,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
