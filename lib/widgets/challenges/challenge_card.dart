import 'package:cap_challenge/generated/i18n.dart';
import 'package:cap_challenge/models/bottle.dart';
import 'package:cap_challenge/models/challenge.dart';
import 'package:cap_challenge/widgets/challenges/challenge_common_views.dart';
import 'package:cap_challenge/widgets/challenges/challenge_details_page.dart';
import 'package:flutter/material.dart';

class ChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final Map<Bottle, int> bottleCollection;
  final Function(Challenge) completeChallenge;

  ChallengeCard(this.challenge, this.bottleCollection, this.completeChallenge);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: new Card(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(12.0),
        ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildNeededBottles(context),
              new Expanded(child: new Container()),
              getRewardView(challenge),
            ],
          ),

          _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildNeededBottles(BuildContext context) {
    Text header = new Text(
      S
          .of(context)
          .requiredProducts,
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
    List<Widget> stackChildren = <Widget>[
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
    ];

    if (challenge.isCompleted) {
      stackChildren.addAll([
        new Positioned.fill(
          child: new Container(
            decoration: new BoxDecoration(color: Colors.grey.withAlpha(220)),
          ),
        ),
        Positioned.fill(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                S
                    .of(context)
                    .completed,
                style: new TextStyle(fontSize: 28.0, color: Colors.white),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40.0,
                ),
              )
            ],
          ),
        )
      ]);
    }

    return new GestureDetector(
      onTap: () => _goToDetails(context, challenge),
      child: new Stack(
        fit: StackFit.passthrough,
        children: stackChildren,
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
          onPressed: () => _goToDetails(context, challenge),
          child: new Text(S
              .of(context)
              .showMore
              .toUpperCase()),
        ),
      ],
    );
  }

  _goToDetails(BuildContext context, Challenge challenge) {
    Navigator
        .of(context)
        .push(new MaterialPageRoute<bool>(
        builder: (context) =>
        new ChallengeDetailsPage(challenge, bottleCollection)))
        .then((challengeCompleted) {
      if (challengeCompleted ?? false) {
        this.completeChallenge(challenge);
      }
    });
  }
}
