class User {
  final String name;
  final int points;

  User.fromMap(Map<dynamic, dynamic> map)
      : name = map['username'],
        points = map['points'];
}
