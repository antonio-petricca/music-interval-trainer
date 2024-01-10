import 'package:flutter/material.dart';

class WidgetBlinkingText extends StatefulWidget {
  final Duration duration;
  final Locale? locale;
  final int? maxLines;
  final double maxOpacity;
  final double minOpacity;
  final TextOverflow? overflow;
  final Color? selectionColor;
  final bool? softWrap;
  final double startOpacity;
  final TextScaler? textScaler;
  final String? semanticsLabel;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final ValueNotifier<String> textNotifier;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  const WidgetBlinkingText({
    super.key,
    this.duration = const Duration(seconds: 1, milliseconds: 500),
    this.locale,
    this.maxLines,
    this.maxOpacity = 1.0,
    this.minOpacity = 0.1,
    this.overflow,
    this.selectionColor,
    this.semanticsLabel,
    this.softWrap,
    this.startOpacity = 0.0,
    this.style,
    this.strutStyle,
    required this.textNotifier,
    this.textAlign,
    this.textDirection,
    this.textScaler,
    this.textWidthBasis,
    this.textHeightBehavior
  });

  @override
  WidgetBlinkingTextState createState() => WidgetBlinkingTextState();
}

class WidgetBlinkingTextState extends State<WidgetBlinkingText> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: ValueListenableBuilder(
        valueListenable: widget.textNotifier,
        builder: (context, value, child) {
          return Text(
            value,
              locale: widget.locale,
              maxLines: widget.maxLines,
              overflow: widget.overflow,
              selectionColor: widget.selectionColor,
              semanticsLabel: widget.semanticsLabel,
              softWrap: widget.softWrap,
              style: widget.style,
              strutStyle: widget.strutStyle,
              textAlign: widget.textAlign,
              textDirection: widget.textDirection,
              textScaler: widget.textScaler,
              textWidthBasis: widget.textWidthBasis,
              textHeightBehavior: widget.textHeightBehavior
          );
        },
      ),
    );
  }
}
