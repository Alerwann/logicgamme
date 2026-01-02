import 'package:flutter/material.dart';

class StaticBackgroundGrid extends StatelessWidget {
  final int levelSize;
  const StaticBackgroundGrid({super.key, required this.levelSize});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: levelSize,
      ),
      itemCount: levelSize * levelSize,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
      ),
    );
  }
}
