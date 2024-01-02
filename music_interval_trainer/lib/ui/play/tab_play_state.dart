import 'package:flutter/material.dart';
import 'package:io.github.antoniopetricca.music_interval_trainer/ui/play/tab_play.dart';

class TabPlayState extends State<TabPlay> with SingleTickerProviderStateMixin {
  final Duration _duration = const Duration(milliseconds: 500);
  final String _text = "C";

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Centro il testo
      child: AnimatedOpacity(
        // Animo l'opacità
        opacity: 1.0, // L'opacità finale
        duration: _duration, // La durata dell'animazione
        child: Text(
          // Il testo da mostrare
          _text,
          style: const TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
