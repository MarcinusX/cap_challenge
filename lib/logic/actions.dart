import 'dart:async';

import 'package:cap_challenge/models/bottle.dart';
import 'package:cap_challenge/models/challenge.dart';
import 'package:cap_challenge/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InitAction {}

class AddCodeAction {
  final String code;
  final Completer completer;

  AddCodeAction(this.code, this.completer);
}

class CompleteChallengeAction {
  final Challenge challenge;

  CompleteChallengeAction(this.challenge);
}

class LoginWithGoogleAction {}

class UserProvidedAction {
  final FirebaseUser user;

  UserProvidedAction(this.user);
}

class LogoutAction {}

class CounterUpdatedAction {
  final int counter;

  CounterUpdatedAction(this.counter);
}

class PointsUpdatedAction {
  final int points;

  PointsUpdatedAction(this.points);
}

class ChallengesUpdatedAction {
  final List<Challenge> challenges;

  ChallengesUpdatedAction(this.challenges);
}

class ChallengeAddedAction {
  final Challenge challenge;

  ChallengeAddedAction(this.challenge);
}

class ChallengeUpdatedAction {
  final String key;
  final bool isCompleted;

  ChallengeUpdatedAction(this.key, this.isCompleted);
}

class CapsChangedAction {
  final Map<Bottle, int> collection;

  CapsChangedAction(this.collection);
}

class TicketsUpdatedAction {
  final int tickets;

  TicketsUpdatedAction(this.tickets);
}

class RankingUpdatedAction {
  final List<User> ranking;

  RankingUpdatedAction(this.ranking);
}
