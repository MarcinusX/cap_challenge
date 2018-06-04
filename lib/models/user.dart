class User {
  final String name;
  final String email;
  final int points;

  User.fromMap(Map<dynamic, dynamic> map)
      : name = map['username'],
        points = map['points'],
        email = map['email'];
}
