import 'package:cap_challenge/models/user.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatelessWidget {
  final List<User> ranking;

  const RankingPage({Key key, this.ranking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemBuilder: (context, index) {
        User user = ranking[index];
        return new ListTile(
          leading: new Text("${index + 1}"),
          title: new Text(user.name),
          trailing: new Text("${user.points}p"),
        );
      },
      itemCount: ranking.length,
    );
  }
}
