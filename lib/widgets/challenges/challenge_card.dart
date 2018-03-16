import 'package:cap_challenge/models/challenge.dart';
import 'package:flutter/material.dart';

class ChallengeCard extends StatelessWidget {
  final Challenge challenge;

  ChallengeCard(this.challenge);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: new Card(
        elevation: 8.0,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildImageStack(context),
            new Text("Under image"),
          ],
        ),
      ),
    );
  }

  Stack _buildImageStack(BuildContext context) {
    return new Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        new Image.network(
          challenge.photoUrl,
          height: 200.0,
          fit: BoxFit.cover,
        ),
        new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Container(
              height: 70.0,
              alignment: Alignment.bottomCenter,
              child: new Text(
                challenge.name,
                style: Theme
                    .of(context)
                    .textTheme
                    .display2
                    .copyWith(color: Colors.black),
              ),
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  _getDifficultyColor(challenge),
                  const Color(0x00FFFFFF),
                ],
              )),
            ),
          ],
        ),
      ],
    );
  }

  Color _getDifficultyColor(Challenge challenge) {
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
}
