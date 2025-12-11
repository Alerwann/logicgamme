

//botom bar et pages seroint crées ici exemple après
import 'package:flutter/material.dart';

class HomeBottomBar extends StatefulWidget {
  const HomeBottomBar({super.key});

  @override
  State<HomeBottomBar> createState() => _HomeBottomBarState();
}

class _HomeBottomBarState extends State<HomeBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text("Everyone"),),
    body: Center(child: Text("ça marche"),),
    );
  }
}


