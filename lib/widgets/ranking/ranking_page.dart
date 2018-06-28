import 'package:cap_challenge/logic/app_state.dart';
import 'package:cap_challenge/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return new _ViewModel(
          ranking: store.state.usersRanking,
        );
      },
      builder: (BuildContext context, _ViewModel vm) {
        return new ListView.builder(
          padding: new EdgeInsets.only(top: 8.0),
          itemCount: vm.ranking.length,
          itemBuilder: (context, index) {
            User user = vm.ranking[index];
            Color color = getColor(index);
            FontWeight fontWeight = getFontWeight(index);
            double size = getFontSize(index);

            TextStyle style = new TextStyle(
              color: color,
              fontWeight: fontWeight,
              fontSize: size,
            );

            return new ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: new Text(
                  "${index + 1}",
                  style: style,
                ),
              ),
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
        );
      },
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

class _ViewModel {
  final List<User> ranking;

  _ViewModel({this.ranking});
}
