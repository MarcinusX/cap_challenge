import 'package:cap_challenge/models/challenge.dart';
import 'package:cap_challenge/widgets/challenges/challenge_common_views.dart';
import 'package:flutter/material.dart';

class ChallengeDetailsPage extends StatelessWidget {
  final Challenge challenge;

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
                buildDifficultyStars(challenge),
                buildDifficultyStars(challenge),
                buildDifficultyStars(challenge),
                buildDifficultyStars(challenge),
                buildDifficultyStars(challenge),
                buildDifficultyStars(challenge),
                buildDifficultyStars(challenge),
                buildDifficultyStars(challenge),
                buildDifficultyStars(challenge),
                buildDifficultyStars(challenge),
                buildDifficultyStars(challenge),
                buildDifficultyStars(challenge),
                buildDifficultyStars(challenge),
                buildDifficultyStars(challenge),
                buildDifficultyStars(challenge),
                buildDifficultyStars(challenge),
                buildDifficultyStars(challenge),
                buildDifficultyStars(challenge),
              ],
            ),
          ),
        ],
      ),
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
