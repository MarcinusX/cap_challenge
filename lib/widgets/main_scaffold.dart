import 'dart:async';

import 'package:cap_challenge/logic/auth_service.dart';
import 'package:cap_challenge/models/add_code_result.dart';
import 'package:cap_challenge/models/bottle.dart';
import 'package:cap_challenge/models/challenge.dart';
import 'package:cap_challenge/models/user.dart';
import 'package:cap_challenge/widgets/challenges/challenges_page.dart';
import 'package:cap_challenge/widgets/code_cap.dart';
import 'package:cap_challenge/widgets/collection/collection_page.dart';
import 'package:cap_challenge/widgets/daily_challenge/timer_page.dart';
import 'package:cap_challenge/widgets/points_indicator.dart';
import 'package:cap_challenge/widgets/profile_dialog.dart';
import 'package:cap_challenge/widgets/ranking/ranking_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MainScaffold extends StatefulWidget {
  final Map<Bottle, int> bottleCollection = {};
  final List<Challenge> challenges = [];
  final List<User> usersRanking = [];

  @override
  State<StatefulWidget> createState() {
    return new MainScaffoldState();
  }
}

class MainScaffoldState extends State<MainScaffold>
    with SingleTickerProviderStateMixin {
  DatabaseReference userRef = FirebaseDatabase.instance
      .reference()
      .child('users')
      .child(AuthService.instance.currentUser.uid);
  bool _showFab = true;
  bool _isCapOpened = false;
  int points = 0;
  int _page = 0;
  int tickets = 0;

  Widget _buildBody() {
    switch (_page) {
      case 0:
        return new TimerPage();
      case 1:
        return new CollectionPage(
          bottleCollection: widget.bottleCollection,
          numberOfTickets: tickets,
        );
      case 2:
        return new ChallengesPage(
            widget.bottleCollection, widget.challenges, completeChallenge);
      case 3:
        return new RankingPage(ranking: widget.usersRanking);
      default:
        return new TimerPage();
    }
  }

  Widget _buildFab(BuildContext context) {
    switch (_page) {
      case 1:
        return _createHeroFab(context);
      default:
        return new Container();
    }
  }

  completeChallenge(Challenge challenge) {
    challenge.requirements.forEach((bottle, quantity) {
      widget.bottleCollection[bottle] -= quantity;
    });

    userRef.child('bottles').set(widget.bottleCollection
        .map((bottle, quantity) => new MapEntry(bottle.dbKey, quantity)));

    userRef.child('tickets').set(tickets + 1);

    userRef.child('currentChallenges/${challenge.key}').set(true);

    userRef.child('points').set(points + challenge.reward);
  }

  @override
  void initState() {
    super.initState();
    userRef.child('bottles').onValue.listen(_onBottlesValue);
    userRef.child('currentChallenges').onChildAdded.listen(_onChallengeAdded);
    userRef
        .child('currentChallenges')
        .onChildChanged
        .listen(_onChallengeChanged);
    userRef.child('points').onValue.listen(_onPointsValue);
    userRef
        .child('tickets')
        .onValue
        .listen(_onTicketsValue);
    FirebaseDatabase.instance.reference().child('users')
      ..onValue.listen(_onUsersInRanking);
  }

  void _onUsersInRanking(Event event) {
    widget.usersRanking.clear();
    (event.snapshot.value as Map<dynamic, dynamic>).forEach((key, val) {
      User user = User.fromMap(val);
      widget.usersRanking.add(user);
    });
    setState(() {
      widget.usersRanking.sort((u1, u2) => u2.points.compareTo(u1.points));
    });
  }

  void _onChallengeChanged(Event event) {
    setState(() {
      widget.challenges
          .singleWhere((challenge) => challenge.key == event.snapshot.key)
          .isCompleted = event.snapshot.value;
    });
  }

  void _onPointsValue(Event event) {
    setState(() {
      points = event.snapshot.value;
    });
  }

  void _onTicketsValue(Event event) {
    if (event.snapshot.value == null) {
      return;
    }
    setState(() {
      tickets = event.snapshot.value;
    });
  }

  void _onChallengeAdded(Event event) async {
    DataSnapshot dataSnapshot = await FirebaseDatabase.instance
        .reference()
        .child('challenges/${event.snapshot.key}')
        .once();
    Challenge challenge =
        new Challenge.fromMap(dataSnapshot.value, dataSnapshot.key);
    challenge.isCompleted = event.snapshot.value;
    setState(() => widget.challenges.add(challenge));
  }

  void _onBottlesValue(event) {
    setState(() {
      Map<dynamic, dynamic> bottles = event.snapshot.value;
      bottles?.forEach((key, val) {
        Bottle bottle = new Bottle(key);
        if (val == 0) {
          widget.bottleCollection.remove(bottle);
        } else {
          widget.bottleCollection[bottle] = val;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text("Cap challenge"),
        actions: <Widget>[
          new Center(
            child: new PointsIndicator(
              actualPoints: points,
            ),
          ),
          new GestureDetector(
            child: new Padding(
              padding: const EdgeInsets.all(6.0),
              child: new CircleAvatar(
                radius: 22.0,
                backgroundImage:
                    new NetworkImage(AuthService.instance.currentUser.photoUrl),
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) =>
                new ProfileDialog(
                  points: points,
                  tickets: tickets,
                  rankingPlace: widget.usersRanking.indexWhere((user) =>
                  user.email ==
                      AuthService.instance.currentUser.email) +
                      1,
                ),
              );
            },
          ),
        ],
      ),
      body: new Material(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.vertical(top: Radius.circular(24.0)),
        ),
        child: _buildBody(),
      ),
      backgroundColor: Colors.red,
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: new Icon(Icons.whatshot),
            title: new Text("Zadanie dnia"),
          ),
          new BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: new Icon(Icons.view_module),
            title: new Text("Kolekcja"),
          ),
          new BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: new Icon(Icons.star),
            title: new Text("Wyzwania"),
          ),
          new BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: new Icon(Icons.swap_vert),
            title: new Text("Ranking"),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        onTap: _navigationTapped,
        currentIndex: _page,
      ),
      floatingActionButton: new Builder(
        builder: (BuildContext context) => _buildFab(context),
      ),
    );
  }

  void _navigationTapped(int page) {
    setState(() => this._page = page);
  }

  Widget _createHeroFab(BuildContext context) {
    return new Hero(
      tag: "fab-cap",
      child: _showFab ? _createActualFab(context) : new Container(),
    );
  }

  Widget _createActualFab(BuildContext context) {
    return new FloatingActionButton(
      child: new Icon(Icons.add),
      tooltip: "Dodaj kod spod nakrętki",
      onPressed: () {
        _pushCapView(context).then((dynamic result) {
          _onCapClosed();
          if (result is ScannedQRCodeResult) {
            _handleQrCode(result, context);
          } else if (result is AddedCodeResult) {
            if (result.isOk) {
              Scaffold.of(context).showSnackBar(new SnackBar(
                  content:
                      new Text("Butelka została dodana do Twojej kolekcji")));
            }
          }
        });
        _onCapOpened();
      },
    );
  }

  Future _pushCapView(BuildContext context) {
    return Navigator.of(context).push(
      new HeroDialogRoute(
        builder: (BuildContext context) {
          return new Center(
            child: new CodeCap(),
          );
        },
      ),
    );
  }

  void _handleQrCode(ScannedQRCodeResult result, BuildContext context) {
    Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text(result.qrCode),
        ));
  }

  _onCapClosed() {
    setState(() => _isCapOpened = false);
    new Future.delayed(
      const Duration(milliseconds: 5),
      () => setState(() => _showFab = true),
    );
  }

  _onCapOpened() {
    setState(() => _isCapOpened = true);
    new Future.delayed(
      const Duration(milliseconds: 300),
      () => setState(
            () {
              if (_isCapOpened) {
                _showFab = false;
              }
            },
          ),
    );
  }
}
