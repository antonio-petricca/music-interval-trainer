import 'package:flutter/material.dart';

import '../../common/ui/fonts_catalog.dart';
import '../../common/ui/widget_blinking_text.dart';

class WidgetPlayChallengePanel extends StatelessWidget {
  final ValueNotifier<String> intervalValueNotifier;
  final ValueNotifier<String> keyValueNotifier;

  const WidgetPlayChallengePanel({
    super.key,
    required this.intervalValueNotifier,
    required this.keyValueNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Stack(
        children: [
          _buildIntervalPanel(),
          Positioned(
            top: 10,
            right: 10,
            child: SizedBox(
              width: 80.0,
              height: 80.0,
              child: _buildKeyPanel(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntervalPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 20, top: 90),
      child: ValueListenableBuilder(
        valueListenable: intervalValueNotifier,
        builder: (context, value, child) {
          return Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).buttonTheme.colorScheme?.primary,
              fontFamily: FontsCatalog.roundedLedBoard7,
              fontSize: 60,
            ),
          );
        },
      ),
    );
  }

  Widget _buildKeyPanel(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.only(top: 20), // Compensate "fontSize"
                child: WidgetBlinkingText(
                  textAlign: TextAlign.center,
                  textNotifier: keyValueNotifier,
                  style: TextStyle(
                    color: Theme.of(context).buttonTheme.colorScheme?.error,
                    fontFamily: FontsCatalog.roundedLedBoard7,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
