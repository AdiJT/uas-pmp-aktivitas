import 'dart:math';

import 'package:flutter/material.dart';

class Schedule {
  int id;
  String title;
  String? description;
  Day day;
  TimeOfDay time;
  Duration duration;

  Schedule({
    int? id,
    required this.title,
    this.description,
    required this.day,
    required this.time,
    required this.duration,
  }) : id = id ?? Random().nextInt(pow(2, 32).toInt() - 1);

  Schedule.rest(Day day)
      : this(
          title: "Libur",
          day: day,
          time: const TimeOfDay(hour: 0, minute: 0),
          duration: const Duration(hours: 24),
        );

  Schedule.fromMap(Map<String, Object?> map)
      : id = map['id'] as int,
        title = map['title'] as String,
        description = map['description'] as String?,
        day = dayFromInt(map['day'] as int),
        time = TimeOfDay.fromDateTime(DateTime.parse(map['time'] as String)),
        duration = Duration(seconds: map['duration'] as int);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'day': day.toInt(),
      'time': DateTime(0, 0, 0, time.hour, time.minute).toString(),
      'duration': duration.inSeconds,
    };
  }
}

enum Day { senin, selasa, rabu, kamis, jumat, sabtu, minggu }

extension DayTimeExtension on Day {
  String toCascadeString() {
    return switch (this) {
      Day.senin => 'Senin',
      Day.selasa => 'Selasa',
      Day.rabu => 'Rabu',
      Day.kamis => 'Kamis',
      Day.jumat => 'Jumat',
      Day.sabtu => 'Sabtu',
      Day.minggu => 'Minggu',
    };
  }

  int toInt() {
    return switch (this) {
      Day.senin => 1,
      Day.selasa => 2,
      Day.rabu => 3,
      Day.kamis => 4,
      Day.jumat => 5,
      Day.sabtu => 6,
      Day.minggu => 7,
    };
  }
}

Day dayFromDateTime(DateTime dateTime) {
  return dayFromInt(dateTime.weekday);
}

Day dayFromInt(int i) {
  return switch (i) {
    1 => Day.senin,
    2 => Day.selasa,
    3 => Day.rabu,
    4 => Day.kamis,
    5 => Day.jumat,
    6 => Day.sabtu,
    7 => Day.minggu,
    _ => throw ArgumentError.value(i, 'i', 'Out of bounds')
  };
}
