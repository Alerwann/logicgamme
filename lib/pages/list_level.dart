import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListLevel extends ConsumerStatefulWidget {
  const ListLevel({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListLevel();
}

class _ListLevel extends ConsumerState<ListLevel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Liste de tous les niveaux disponibles")),
      body: Text("Tu aurras accès à tous les niveaux"),
    );
  }
}
