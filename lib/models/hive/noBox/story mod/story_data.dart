import 'package:hive/hive.dart';

part 'story_data.g.dart';

@HiveType(typeId: 13)
class StoryData {
  @HiveField(0)
  final String enigme;
  @HiveField(1)
  final String solution;

  StoryData({required this.enigme, required this.solution});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryData &&
          enigme == other.enigme &&
          solution == other.solution;

  @override
  int get hashCode => Object.hash(enigme, solution);
}
