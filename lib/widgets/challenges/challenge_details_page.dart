import 'dart:math' as math;

import 'package:cap_challenge/models/bottle.dart';
import 'package:cap_challenge/models/challenge.dart';
import 'package:cap_challenge/widgets/challenges/challenge_common_views.dart';
import 'package:flutter/material.dart';
import 'package:sliver_fab/sliver_fab.dart';

class ChallengeDetailsPage extends StatefulWidget {
  final Challenge challenge;
  final Map<Bottle, int> bottleCollection;

  ChallengeDetailsPage(this.challenge, this.bottleCollection);

  @override
  ChallengeDetailsPageState createState() {
    return new ChallengeDetailsPageState();
  }
}

class ChallengeDetailsPageState extends State<ChallengeDetailsPage> {
  final double _rowHeight = 32.0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SliverFab(
        floatingActionButton:
            _buildFab(widget.bottleCollection, widget.challenge),
        slivers: <Widget>[
          _buildSliverAppBar(),
          new SliverList(
            delegate: new SliverChildListDelegate(
              <Widget>[
                _buildCompletedLabel(widget.challenge.isCompleted),
                _buildMissingBottlesLabel(
                    widget.bottleCollection, widget.challenge),
                //_buildDifficultyRow(),
                _buildPriceRow(),
              ]..addAll(_buildRequirementsRows(widget.challenge)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFab(Map<Bottle, int> collection, Challenge challenge) {
    if (_canChallengeBeCompleted(collection, challenge) &&
        !challenge.isCompleted) {
      return new Builder(
        builder: (context) => new FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: new Icon(Icons.check),
            ),
      );
    } else {
      return new Container();
    }
  }

  Padding _buildPriceRow() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: new Row(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: new Text("Nagroda:"),
          ),
          getRewardView(widget.challenge),
        ],
      ),
    );
  }

  List<Widget> _buildRequirementsRows(Challenge challenge) {
    return widget.challenge.requirements.keys.map((bottle) {
      return _buildRequirementRow(
        context,
        bottle,
        widget.challenge.requirements[bottle],
        widget.bottleCollection[bottle] ?? 0,
      );
    }).toList();
  }

  Widget _buildMissingBottlesLabel(
      Map<Bottle, int> collection, Challenge challenge) {
    if (_canChallengeBeCompleted(collection, challenge)) {
      return new Container();
    } else {
      return new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new Text(
          "Brakuje Ci tylko ${_getMissingBottles(
              collection, challenge)}!",
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  bool _canChallengeBeCompleted(
      Map<Bottle, int> collection, Challenge challenge) {
    return challenge.isCompleted || _getMissingBottles(collection, challenge) == 0;
  }

  int _getMissingBottles(Map<Bottle, int> collection, Challenge challenge) {
    int missing = 0;
    challenge.requirements.forEach((bottle, required) {
      int diff = required - (collection[bottle] ?? 0);
      if (diff > 0) {
        missing += diff;
      }
    });
    return missing;
  }

  Widget _buildRequirementRow(
      BuildContext context, Bottle bottle, int required, int current) {
    return new ListTile(
      title: new Text(bottleNameToString(bottle.bottleName)),
      subtitle: new Text(bottleCapacityToLongString(bottle.capacity)),
      trailing: _buildProgressIndicator(required, current),
    );
  }

  Widget _buildProgressIndicator(int required, int current) {
    if (widget.challenge.isCompleted) {
      current = required;
    }
    int viewCurrent = math.min(current, required);
    int missing = required - viewCurrent;
    List<Widget> filledBottles = new Iterable.generate(
      viewCurrent,
      (i) => new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: new Image.asset(
              "images/bottle_filled.png",
              height: _rowHeight,
              color: widget.challenge.isCompleted ? Colors.grey : Colors.black,
            ),
          ),
    ).toList();
    List<Widget> emptyBottles = new Iterable.generate(
      missing,
      (i) => new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: new Image.asset(
              "images/bottle_empty.png",
              height: _rowHeight,
            ),
          ),
    ).toList();
    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: filledBottles..addAll(emptyBottles),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return new SliverAppBar(
      expandedHeight: 256.0,
      pinned: true,
      flexibleSpace: new FlexibleSpaceBar(
        title: new Text(widget.challenge.name),
        background: new Container(
          color: Colors.white,
          child: new Hero(
            tag: "challenge_image_${widget.challenge.name}",
            child: new Stack(
              fit: StackFit.expand,
              children: <Widget>[
                new Image.network(
                  widget.challenge.photoUrl,
                  height: 256.0,
                  fit: BoxFit.cover,
                ),
                const DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: const LinearGradient(
                      begin: const Alignment(0.0, -1.0),
                      end: const Alignment(0.0, -0.4),
                      colors: const <Color>[
                        const Color(0x60FF0000),
                        const Color(0x00FF0000)
                      ],
                    ),
                  ),
                ),
                const DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: const LinearGradient(
                      begin: const Alignment(0.0, 1.0),
                      end: const Alignment(0.0, 0.4),
                      colors: const <Color>[
                        const Color(0x60FF0000),
                        const Color(0x00FF0000)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedLabel(bool isCompleted) {
    if (isCompleted) {
      return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Row(
          children: <Widget>[
            new Icon(Icons.check, color: Colors.green),
            new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: new Text(
                "Wyzwanie wykonane!",
                style: new TextStyle(color: Colors.green, fontSize: 24.0),
              ),
            ),
            new Icon(Icons.check, color: Colors.green),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      );
    } else {
      return new Container();
    }
  }
}
