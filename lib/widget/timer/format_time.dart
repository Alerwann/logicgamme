import 'package:flutter/widgets.dart';

Text formatTime(int duration) {
  final minutes = (duration ~/ 60).toString().padLeft(2, '0');
  final seconds = (duration % 60).toString().padLeft(2, '0');
  // print("le duration de formattime : $duration");
  return Text(
    "$minutes : $seconds",
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Color(0xFF1A1A1A),
    ),
  );
}
