import 'package:cap_challenge/models/user.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatelessWidget {
  final List<User> ranking;

  const RankingPage({Key key, this.ranking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      padding: new EdgeInsets.only(top: 8.0),
      itemBuilder: (context, index) {
        User user = ranking[index];
        Color color = getColor(index);
        FontWeight fontWeight = getFontWeight(index);
        double size = getFontSize(index);

        TextStyle style = new TextStyle(color: color, fontWeight: fontWeight, fontSize: size,);

        return new ListTile(
          leading: new Center(
              child: new Text(
            "${index + 1}",
            style: style,
          )),
          title: new Text(
            user.name,
            style: style,
          ),
          trailing: new Text(
            "${user.points}p",
            style: style,
          ),
        );
      },
      itemCount: ranking.length,
    );
  }

  Color getColor(int index) {
    switch (index) {
      case 0:
        return Colors.yellow[800];
      case 1:
        return Colors.grey[500];
      case 2:
        return Colors.brown;
      default:
        return Colors.black;
    }
  }

  double getFontSize(int index) {
    switch (index) {
      case 0:
        return 22.0;
      case 1:
        return 20.0;
      case 2:
        return 18.0;
      default:
        return 16.0;
    }
  }

  FontWeight getFontWeight(int index) {
    switch (index) {
      case 0:
        return FontWeight.w700;
      case 1:
        return FontWeight.w600;
      case 2:
        return FontWeight.w500;
      default:
        return FontWeight.normal;
    }
  }
}
