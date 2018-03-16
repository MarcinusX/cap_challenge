import 'package:cap_challenge/models/bottle.dart';

class Challenge {
  final Map<Bottle, int> requirements;
  final int reward;
  final String photoUrl;
  final String name;
  final Difficulty difficulty;

  Challenge(
      {this.requirements,
      this.reward,
      this.photoUrl,
      this.name,
      this.difficulty});
}

enum Difficulty {
  EASY,
  MEDIUM,
  HARD,
}
