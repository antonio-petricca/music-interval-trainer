import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/play/view_play.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/view_settings.dart';

import 'about/view_about.dart';

class ViewHome extends StatefulWidget {
  const ViewHome({super.key});

  @override
  ViewHomeState createState() => ViewHomeState();
}

class ViewHomeState extends State<ViewHome> {
  int _selectedIndex = 0;
  final GlobalKey<ViewPlayState> _viewPlayKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.appTitle),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            const ViewAbout(),
            const ViewSettings(),
            ViewPlay(key: _viewPlayKey),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline),
              label: 'About',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow_outlined),
              label: 'Play',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _askForPlayViewExitConfirmation(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.dialogTitleWarning,
          ),
          content: Text(
            AppLocalizations.of(context)!.viewPlay_StopAlert_Message,
          ),
          actions: [
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.buttonYes,
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = index;
                });

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.buttonNo,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    if (2 == _selectedIndex) {
      _viewPlayKey.currentState?.stop(
        () {
          setState(() {
            _selectedIndex = index;
          });
        },
      );

      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }
}
