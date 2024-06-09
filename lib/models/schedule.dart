import 'package:flutter/material.dart';

class Schedule {
  String title;
  String? description;
  Day day;
  TimeOfDay time;
  Duration duration;

  Schedule(
      {required this.title,
      this.description,
      required this.day,
      required this.time,
      required this.duration});

  Schedule.rest(Day day)
      : this(
          title: "Libur",
          day: day,
          time: const TimeOfDay(hour: 0, minute: 0),
          duration: const Duration(hours: 24),
        );
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
      _ => throw Exception(),
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
