import 'package:cap_challenge/models/bottle.dart';

class Challenge {
  final String key;
  final Map<Bottle, int> requirements;
  final int reward;
  final String photoUrl;
  final String name;
  final Difficulty difficulty;
  bool isCompleted = false;

  Challenge({this.key,
    this.requirements,
    this.reward,
    this.photoUrl,
    this.name,
    this.difficulty});

  Challenge.fromMap(Map<dynamic, dynamic> map, String key)
      : key = key,
        reward = map['reward'],
        photoUrl = map['photoUrl'],
        name = map['name'],
        difficulty = Difficulty.EASY,
        requirements = (map['requirements'] as Map<dynamic, dynamic>)
            .map<Bottle, int>((name, val) =>
        new MapEntry(new Bottle(name), val));

  int get totalBottles => requirements.values.reduce((i1, i2) => i1 + i2);

  List<BottleName> get bottleNames =>
      requirements.keys.map((bottle) => bottle.bottleName).toSet().toList();
}

enum Difficulty {
  EASY,
  MEDIUM,
  HARD,
}
