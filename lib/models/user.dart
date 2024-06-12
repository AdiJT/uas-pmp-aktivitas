import 'dart:math';

class User {
  int id;
  String userName;
  String password;

  User({
    int? id,
    required this.userName,
    required this.password,
  }) : id = id ?? Random().nextInt((pow(2, 32) - 1).toInt());

  User.fromMap(Map<String, Object?> map)
      : id = map['id'] as int,
        userName = map['userName'] as String,
        password = map['password'] as String;

  Map<String, Object?> toMap() {
    return {
      'id' : id,
      'userName' : userName,
      'password' : password,
    };
  }
}
