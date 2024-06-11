import 'dart:math';

class Activity {
  int id;
  String name;
  String description;
  DateTime date;
  Duration duration;
  bool isDone;

  Activity({
    int? id,
    required this.name,
    required this.description,
    required this.date,
    required this.duration,
    required this.isDone,
  }) : id = id ?? Random().nextInt(pow(2, 32).toInt() - 1);

  Activity.fromMap(Map<String, Object?> map)
      : id = map['id'] as int,
        name = map['name'] as String,
        description = map['description'] as String,
        date = DateTime.parse(map['date'] as String),
        duration = Duration(seconds: map['duration'] as int),
        isDone = (map['isDone'] as int) == 1;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date.toString(),
      'duration': duration.inSeconds,
      'isDone': isDone ? 1 : 0,
    };
  }
}
