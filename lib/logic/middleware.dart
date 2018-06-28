import 'dart:async';

import 'package:cap_challenge/logic/actions.dart';
import 'package:cap_challenge/logic/app_state.dart';
import 'package:cap_challenge/models/bottle.dart';
import 'package:cap_challenge/models/challenge.dart';
import 'package:cap_challenge/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:redux/redux.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

middleware(Store<AppState> store, action, NextDispatcher next) {
  print("middleware sees ${action.runtimeType}");
  if (action is InitAction) {
    _handleInitAction(store);
  } else if (action is UserProvidedAction) {
    _handleUserProvidedAction(store, action.user);
  } else if (action is CompleteChallengeAction) {
    _completeChallenge(action.challenge, store);
  }
  next(action);
}

_handleInitAction(Store<AppState> store) async {
  FirebaseUser user = await auth.currentUser();
  if (user != null) {
    store.dispatch(new UserProvidedAction(user));
  }
  database.reference().child("counter").onValue.listen((Event ev) {
    int counter = ev.snapshot.value % 10;
    store.dispatch(new CounterUpdatedAction(counter));
  });
  database.reference().child('users')
    ..onValue.listen((Event event) {
      List<User> ranking = [];
      (event.snapshot.value as Map<dynamic, dynamic>).forEach((key, val) {
        User user = User.fromMap(val);
        ranking.add(user);
      });
      ranking.sort((u1, u2) => u2.points.compareTo(u1.points));
      store.dispatch(new RankingUpdatedAction(ranking));
    });
}

StreamSubscription<Event> bottlesSubscription;
StreamSubscription<Event> addChallengeSubscription;
StreamSubscription<Event> changeChallengeSubscription;
StreamSubscription<Event> pointsSubscription;
StreamSubscription<Event> ticketsSubscription;

_handleUserProvidedAction(Store<AppState> store, FirebaseUser user) async {
  await Future.wait([
    bottlesSubscription?.cancel() ?? new Future(() {}),
    addChallengeSubscription?.cancel() ?? new Future(() {}),
    changeChallengeSubscription?.cancel() ?? new Future(() {}),
    pointsSubscription?.cancel() ?? new Future(() {}),
    ticketsSubscription?.cancel() ?? new Future(() {}),
  ]);

  if (user == null) {
    return;
  }

  DatabaseReference userRef =
      FirebaseDatabase.instance.reference().child('users').child(user.uid);
  bottlesSubscription = userRef
      .child('bottles')
      .onValue
      .listen((ev) => _onBottlesValue(ev, store));
  addChallengeSubscription = userRef
      .child('currentChallenges')
      .onChildAdded
      .listen((ev) => _onChallengeAdded(ev, store));
  changeChallengeSubscription = userRef
      .child('currentChallenges')
      .onChildChanged
      .listen((ev) => store.dispatch(
          new ChallengeUpdatedAction(ev.snapshot.key, ev.snapshot.value)));
  pointsSubscription = userRef.child('points').onValue.listen((Event ev) {
    store.dispatch(new PointsUpdatedAction(ev.snapshot.value));
  });
  ticketsSubscription = userRef.child('tickets').onValue.listen((Event ev) {
    store.dispatch(new TicketsUpdatedAction(ev.snapshot.value ?? 0));
  });
}

void _onChallengeAdded(Event event, Store store) async {
  DataSnapshot dataSnapshot = await FirebaseDatabase.instance
      .reference()
      .child('challenges/${event.snapshot.key}')
      .once();
  Challenge challenge =
      new Challenge.fromMap(dataSnapshot.value, dataSnapshot.key);
  challenge.isCompleted = event.snapshot.value;
  store.dispatch(new ChallengeAddedAction(challenge));
}

void _onBottlesValue(event, Store<AppState> store) {
  Map<Bottle, int> bottleCollection = {};
  Map<dynamic, dynamic> bottles = event.snapshot.value;
  bottles?.forEach((key, val) {
    if (val != 0) {
      Bottle bottle = new Bottle(key);
      bottleCollection[bottle] = val;
    }
  });
  store.dispatch(new CapsChangedAction(bottleCollection));
}

_completeChallenge(Challenge challenge, Store<AppState> store) async {
  FirebaseUser user = await auth.currentUser();
  DatabaseReference userRef =
      FirebaseDatabase.instance.reference().child('users').child(user.uid);

  Map<Bottle, int> collection = store.state.collection;

  challenge.requirements.forEach((bottle, quantity) {
    collection[bottle] -= quantity;
  });

  userRef.child('bottles').set(collection
      .map((bottle, quantity) => new MapEntry(bottle.dbKey, quantity)));

  userRef.child('tickets').set(store.state.tickets + 1);

  userRef.child('currentChallenges/${challenge.key}').set(true);

  userRef.child('points').set(store.state.points + challenge.reward);
}
