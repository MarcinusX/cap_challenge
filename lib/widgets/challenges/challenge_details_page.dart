import 'dart:math' as math;

import 'package:cap_challenge/models/bottle.dart';
import 'package:cap_challenge/models/challenge.dart';
import 'package:cap_challenge/widgets/challenges/challenge_common_views.dart';
import 'package:flutter/material.dart';

List<Bottle> bottleCollection = [
  new Bottle(BottleName.SPRITE, Capacity.CAN_300, 50),
  new Bottle(BottleName.SPRITE, Capacity.PLASTIC_500, 10),
  new Bottle(BottleName.COCA_COLA_ZERO, Capacity.PLASTIC_1L, 50),
  new Bottle(BottleName.SPRITE, Capacity.PLASTIC_2L, 10),
  new Bottle(BottleName.COCA_COLA, Capacity.PLASTIC_2L, 50),
  new Bottle(BottleName.SPRITE, Capacity.PLASTIC_500, 10),
  new Bottle(BottleName.SPRITE, Capacity.PLASTIC_1L, 50),
  new Bottle(BottleName.SPRITE, Capacity.PLASTIC_2L, 10),
];

class ChallengeDetailsPage extends StatelessWidget {
  final Challenge challenge;

  double _rowHeight = 32.0;

  ChallengeDetailsPage(this.challenge);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new CustomScrollView(
        slivers: <Widget>[
          _buildSliverAppBar(),
          new SliverList(
            delegate: new SliverChildListDelegate(
              <Widget>[
                buildDifficultyStars(challenge),
              ]
                ..addAll(challenge.requirements.keys.map((bottle) {
                  return _buildRequirementRow(
                    context,
                    bottle,
                    challenge.requirements[bottle],
                    bottleCollection
                        .where((btl) => btl == bottle)
                        .length,
                  );
                }).toList()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementRow(BuildContext context, Bottle bottle, int required,
      int current) {
//    return new Padding(
//      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//      child: new Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: new Row(
//          children: <Widget>[
//            new Expanded(
//              child: new Text(bottle.toString(),
//                  style: Theme.of(context).textTheme.subhead),
//            ),
//            _buildProgressIndicator(required, current),
//          ],
//        ),
//      ),
//    );
    return new ListTile(
      title: new Text(bottleNameToString(bottle.bottleName)),
      subtitle: new Text(bottleCapacityToString(bottle.capacity)),
      trailing: _buildProgressIndicator(required, current),
    );
  }

  Widget _buildProgressIndicator(int required, int current) {
    int viewCurrent = math.min(current, required);
    int missing = required - viewCurrent;
    List<Widget> filledBottles = new Iterable.generate(
      viewCurrent,
          (i) =>
      new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: new Image.asset(
          "images/bottle_filled.png",
          height: _rowHeight,
            ),
      ),
    ).toList();
    List<Widget> emptyBottles = new Iterable.generate(
      missing,
          (i) =>
      new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: new Image.asset(
          "images/bottle_empty.png",
          height: _rowHeight,
        ),
      ),
    ).toList();
    return new Row(
      children: filledBottles..addAll(emptyBottles),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return new SliverAppBar(
      expandedHeight: 256.0,
      pinned: true,
      flexibleSpace: new FlexibleSpaceBar(
        title: new Text(challenge.name),
        background: new Container(
          color: Colors.white,
          child: new Hero(
            tag: "challenge_image_${challenge.name}",
            child: new Stack(
              fit: StackFit.expand,
              children: <Widget>[
                new Image.network(
                  challenge.photoUrl,
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
}
