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
      new Bottle(BottleName.COCA_COLA, Capacity.PLASTIC_1L, 50): 3,
      new Bottle(BottleName.COCA_COLA_ZERO, Capacity.CAN_300, 10): 1,
    },
    reward: 10000,
    photoUrl:
    'https://www.modelplusmodel.com/images/detailed/mpm_vol.09_p35_06_L.jpg',
    name: "Na smaczek",
    difficulty: Difficulty.EASY,
  ),
  new Challenge(
    requirements: {
      new Bottle(BottleName.COCA_COLA_ZERO, Capacity.PLASTIC_1L, 50): 1,
      new Bottle(BottleName.COCA_COLA_ZERO, Capacity.CAN_300, 10): 4,
      new Bottle(BottleName.COCA_COLA_LIGHT, Capacity.PLASTIC_1L, 50): 1,
      new Bottle(BottleName.COCA_COLA_LIGHT, Capacity.CAN_300, 10): 4,
    },
    reward: 50000,
    photoUrl:
    'https://www.modelplusmodel.com/images/detailed/mpm_vol.09_p35_06_L.jpg',
    name: "Super slim",
    difficulty: Difficulty.MEDIUM,
  ),
  new Challenge(
    requirements: {
      new Bottle(BottleName.SPRITE, Capacity.CAN_300, 50): 3,
      new Bottle(BottleName.SPRITE, Capacity.PLASTIC_500, 10): 3,
      new Bottle(BottleName.SPRITE, Capacity.PLASTIC_1L, 50): 3,
      new Bottle(BottleName.SPRITE, Capacity.PLASTIC_2L, 10): 3,
    },
    reward: 10000,
    photoUrl:
    'https://www.modelplusmodel.com/images/detailed/mpm_vol.09_p35_06_L.jpg',
    name: "Spritnij mnie!",
    difficulty: Difficulty.HARD,
  ),
];