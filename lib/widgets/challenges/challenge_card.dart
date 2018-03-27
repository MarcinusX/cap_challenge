import 'package:cap_challenge/models/bottle.dart';
import 'package:cap_challenge/models/challenge.dart';
import 'package:cap_challenge/widgets/challenges/challenge_common_views.dart';
import 'package:cap_challenge/widgets/challenges/challenge_details_page.dart';
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
            _buildUnderImage(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUnderImage(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildDifficultyIndicator(challenge),
              ),
              new Expanded(child: new Container()),
              getRewardView(challenge),
            ],
          ),
          _buildNeededBottles(context),
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildNeededBottles(BuildContext context) {
    Text header = new Text(
      "Wymagane produkty",
      style: new TextStyle(fontWeight: FontWeight.bold),
    );

    List<Widget> names = challenge.bottleNames
        .take(3)
        .map((name) => new Text(bottleNameToString(name)))
        .toList();

    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Stack(
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[header]..addAll(names),
          ),
          new Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: new Container(
              height: 30.0,
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    const Color(0x00FFFFFF),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageStack(BuildContext context) {
    return new GestureDetector(
      onTap: () => _goToDetails(context, challenge),
      child: new Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          new Hero(
            tag: "challenge_image_${challenge.name}",
            child: new Image.network(
              challenge.photoUrl,
              height: 180.0,
              fit: BoxFit.cover,
            ),
          ),
          new Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: _buildShade(context, challenge),
          ),
          new Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: _buildTitle(challenge, context),
          ),
        ],
      ),
    );
  }

  Widget _buildShade(BuildContext context, Challenge challenge) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Container(
          height: 80.0,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                const Color(0x77FF0000),
                const Color(0x00FFFFFF),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(Challenge challenge, BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text(
            challenge.name,
            style: Theme
                .of(context)
                .textTheme
                .display1
                .copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new FlatButton(
          textColor: Colors.red,
          onPressed: () {},
          child: new Text("UDOSTĘPNIJ"),
        ),
        new FlatButton(
          textColor: Colors.red,
          onPressed: () => _goToDetails(context, challenge),
          child: new Text("POKAŻ WIĘCEJ"),
        ),
      ],
    );
  }

  _goToDetails(BuildContext context, Challenge challenge) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => new ChallengeDetailsPage(challenge)));
  }
}
