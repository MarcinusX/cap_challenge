import 'package:cap_challenge/models/bottle.dart';
import 'package:cap_challenge/models/challenge.dart';
import 'package:cap_challenge/widgets/challenges/challenge_card.dart';
import 'package:flutter/material.dart';

class ChallengesPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: challenges.map((c) => new ChallengeCard(c)).toList(),
    );
  }
}

List<Challenge> challenges = [
  new Challenge(
    requirements: {
      Bottle.COCA_COLA_1L: 3,
      Bottle.ZERO_300: 1,
    },
    reward: 10000,
    photoUrl:
    'https://www.modelplusmodel.com/images/detailed/mpm_vol.09_p35_06_L.jpg',
    name: "Na smaczek",
    difficulty: Difficulty.EASY,
  ),
  new Challenge(
    requirements: {
      Bottle.ZERO_1L: 1,
      Bottle.ZERO_300: 4,
      Bottle.LIGHT_1L: 1,
      Bottle.LIGHT_300: 4,
    },
    reward: 50000,
    photoUrl:
    'https://www.modelplusmodel.com/images/detailed/mpm_vol.09_p35_06_L.jpg',
    name: "Super slim",
    difficulty: Difficulty.MEDIUM,
  ),
  new Challenge(
    requirements: {
      Bottle.SPRITE_300: 3,
      Bottle.SPRITE_500: 3,
      Bottle.SPRITE_1L: 3,
      Bottle.SPRITE_2L: 3,
    },
    reward: 10000,
    photoUrl:
    'https://www.modelplusmodel.com/images/detailed/mpm_vol.09_p35_06_L.jpg',
    name: "Spritnij mnie!",
    difficulty: Difficulty.HARD,
  ),
];