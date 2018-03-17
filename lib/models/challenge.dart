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

  int get totalBottles => requirements.values.reduce((i1, i2) => i1 + i2);

  List<BottleName> get bottleNames =>
      requirements.keys.map((bottle) => bottle.bottleName).toSet().toList();
}

enum Difficulty {
  EASY,
  MEDIUM,
  HARD,
}
