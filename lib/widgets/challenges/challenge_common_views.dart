import 'package:cap_challenge/models/challenge.dart';
import 'package:flutter/material.dart';

Widget buildDifficultyIndicator(Challenge challenge) {
  Color color = getDifficultyColor(challenge);
  String text = _getDiffictultyName(challenge);
  return new Text(
    text,
    style: new TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: 18.0,
    ),
  );
}

String _getDiffictultyName(Challenge challenge) {
  switch (challenge.difficulty) {
    case Difficulty.EASY:
      return "ŁATWE";
    case Difficulty.MEDIUM:
      return "ŚREDNIE";
    case Difficulty.HARD:
      return "TRUDNE";
    default:
      return "";
  }
}

Color getDifficultyColor(Challenge challenge) {
  switch (challenge.difficulty) {
    case Difficulty.EASY:
      return Colors.green;
    case Difficulty.MEDIUM:
      return Colors.yellow[600];
    case Difficulty.HARD:
      return Colors.red;
    default:
      return Colors.white;
  }
}

Widget getRewardView(Challenge challenge) {
  return new Row(
    children: <Widget>[
      new Text(
        challenge.reward.toString(),
        style: new TextStyle(
            color: Colors.yellow[600],
            fontWeight: FontWeight.bold,
            fontSize: 24.0),
      ),
      new Icon(
        Icons.monetization_on,
        color: Colors.yellow[600],
        size: 36.0,
      ),
    ],
  );
}