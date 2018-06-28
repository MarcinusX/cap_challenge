import 'package:cap_challenge/logic/actions.dart';
import 'package:cap_challenge/logic/app_state.dart';
import 'package:cap_challenge/models/bottle.dart';
import 'package:cap_challenge/models/challenge.dart';
import 'package:cap_challenge/widgets/challenges/challenge_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ChallengesPage extends StatelessWidget {
  ChallengesPage();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return new _ViewModel(
          bottleCollection: store.state.collection,
          challenges: store.state.challenges,
          completeChallenge: (challenge) =>
              store.dispatch(new CompleteChallengeAction(challenge)),
        );
      },
      builder: (BuildContext context, _ViewModel vm) {
        return new ListView(
          children: vm.challenges
              .map((c) =>
          new ChallengeCard(c, vm.bottleCollection, (challenge) {
            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("Wykonano zadanie"),
            ));
            vm.completeChallenge(challenge);
          }))
              .toList(),
        );
      },
    );
  }
}

class _ViewModel {
  final Map<Bottle, int> bottleCollection;
  final List<Challenge> challenges;
  final Function(Challenge) completeChallenge;

  _ViewModel(
      {@required this.bottleCollection, @required this.challenges, @required this.completeChallenge});


}