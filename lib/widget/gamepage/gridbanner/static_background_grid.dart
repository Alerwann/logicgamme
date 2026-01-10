import 'package:flutter/material.dart';


class StaticBackgroundGrid extends StatelessWidget {
  final int sizeLevel;
  const StaticBackgroundGrid({super.key, required this.sizeLevel});

 
  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: sizeLevel,
      ),
      itemCount: sizeLevel * sizeLevel,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
      ),
    );
  }
}
