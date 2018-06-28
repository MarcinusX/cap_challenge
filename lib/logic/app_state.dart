import 'package:cap_challenge/models/bottle.dart';
import 'package:cap_challenge/models/challenge.dart';
import 'package:cap_challenge/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppState {
  final FirebaseUser user;
  final int points;
  final int tickets;
  final int counter;
  final Map<Bottle, int> collection;
  final List<Challenge> challenges;
  final List<User> usersRanking;

  AppState(
      {this.user,
      this.points,
      this.tickets,
      this.counter,
      this.collection,
      this.challenges,
      this.usersRanking});

  AppState copyWith(
      {FirebaseUser user,
      int points,
      int tickets,
      int counter,
      Map<Bottle, int> collection,
      List<Challenge> challenges,
      List<User> usersRanking}) {
    return new AppState(
        user: user ?? this.user,
        points: points ?? this.points,
        tickets: tickets ?? this.tickets,
        counter: counter ?? this.counter,
        collection: collection ?? this.collection,
        challenges: challenges ?? this.challenges,
        usersRanking: usersRanking ?? this.usersRanking);
  }
}
