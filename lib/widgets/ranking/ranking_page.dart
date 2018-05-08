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
        Color color = getColor(index);
        FontWeight fontWeight = getFontWeight(index);
        return new ListTile(
          leading: new Center(child: new Text("${index + 1}",style: new TextStyle(color: color, fontWeight: fontWeight),)),
          title: new Text(user.name,style: new TextStyle(color: color, fontWeight: fontWeight),),
          trailing: new Text("${user.points}p",style: new TextStyle(color: color, fontWeight: fontWeight),),
        );
      },
      itemCount: ranking.length,
    );
  }

  Color getColor(int index) {
    switch(index) {
      case 0: return Colors.yellow[800];
      case 1: return Colors.grey[500];
      case 2: return Colors.brown;
      default: return Colors.black;
    }
  }

  FontWeight getFontWeight(int index) {
    switch(index) {
      case 0: return FontWeight.w700;
      case 1: return FontWeight.w600;
      case 2: return FontWeight.w500;
      default: return FontWeight.normal;
    }
  }
}
