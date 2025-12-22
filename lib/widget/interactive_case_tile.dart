import 'package:clean_temp/models/level/level_model.dart';
import 'package:clean_temp/models/session_state.dart';
import 'package:flutter/material.dart';

/// widget qui retourne les contraintes de chaque case 
class InteractiveCaseTile extends StatefulWidget {
  final LevelModel level;
  final int index;
  final SessionState session;
  const InteractiveCaseTile({
    super.key,
    required this.index,
    required this.level,
    required this.session,
  });

  @override
  State<InteractiveCaseTile> createState() => _InteractiveCaseTileState();
}

class _InteractiveCaseTileState extends State<InteractiveCaseTile> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
