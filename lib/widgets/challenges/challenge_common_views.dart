import 'package:cap_challenge/models/challenge.dart';
import 'package:flutter/material.dart';

Widget buildDifficultyStars(Challenge challenge) {
  Color color = getDifficultyColor(challenge);
  bool secondStarFilled = challenge.difficulty != Difficulty.EASY;
  bool thirdStarFilled = challenge.difficulty == Difficulty.HARD;
  double sizeFilled = 36.0;
  double sizeEmpty = 24.0;
  Icon star1 = new Icon(Icons.star, color: color, size: sizeFilled);
  Icon star2 = new Icon(
    secondStarFilled ? Icons.star : Icons.star_border,
    color: color,
    size: secondStarFilled ? sizeFilled : sizeEmpty,
  );
  Icon star3 = new Icon(
    thirdStarFilled ? Icons.star : Icons.star_border,
    color: color,
    size: thirdStarFilled ? sizeFilled : sizeEmpty,
  );
  return new Row(
    children: <Widget>[
      star1,
      star2,
      star3,
    ],
  );
}

Color getDifficultyColor(Challenge challenge) {
  switch (challenge.difficulty) {
    case Difficulty.EASY:
      return Colors.green;
    case Difficulty.MEDIUM:
      return Colors.yellow;
    case Difficulty.HARD:
      return Colors.red;
    default:
      return Colors.white;
  }
}
