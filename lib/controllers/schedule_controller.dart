import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/models/schedule.dart';
import 'package:get/get.dart';

class ScheduleController extends GetxController {
  final schedules = <Schedule>[
    Schedule(
        title: "Pengolahan Citra Digital",
        day: Day.senin,
        time: const TimeOfDay(hour: 8, minute: 0),
        duration: const Duration(hours: 2)),
    Schedule(
        title: "Rekayasa Perangkat Lunak",
        day: Day.senin,
        time: const TimeOfDay(hour: 11, minute: 0),
        duration: const Duration(hours: 2)),
    Schedule(
        title: "Sistem Informasi Terintegrasi",
        day: Day.senin,
        time: const TimeOfDay(hour: 13, minute: 0),
        duration: const Duration(hours: 2)),
    Schedule.rest(Day.selasa),
    Schedule(
        title: "Analisis Media Sosial",
        day: Day.rabu,
        time: const TimeOfDay(hour: 10, minute: 0),
        duration: const Duration(hours: 2)),
    Schedule(
        title: "Pembelajaran Mesin",
        day: Day.rabu,
        time: const TimeOfDay(hour: 13, minute: 0),
        duration: const Duration(hours: 2)),
    Schedule(
        title: "Data Mining",
        day: Day.kamis,
        time: const TimeOfDay(hour: 8, minute: 0),
        duration: const Duration(hours: 2)),
    Schedule(
        title: "Pemograman Multi Platform",
        day: Day.kamis,
        time: const TimeOfDay(hour: 11, minute: 0),
        duration: const Duration(hours: 2)),
    Schedule(
        title: "Kriptografi",
        day: Day.kamis,
        time: const TimeOfDay(hour: 13, minute: 0),
        duration: const Duration(hours: 2)),
    Schedule.rest(Day.jumat),
    Schedule.rest(Day.sabtu),
    Schedule(
        title: "Gereja",
        day: Day.minggu,
        time: const TimeOfDay(hour: 7, minute: 0),
        duration: const Duration(hours: 2)),
  ].obs;

  List<Schedule> get todaySchedule {
    final today = dayFromDateTime(DateTime.now());

    return schedules.where((s) => s.day == today).toList();
  }

  Map<Day, List<Schedule>> get scheduleByDay {
    final map = {for (var item in Day.values) item: <Schedule>[]};
    for (var s in schedules) {
      map[s.day]!.add(s);
    }

    for (var s in map.values) {
      s.sort((s1, s2) {
        if (s1.time.hour == s2.time.hour) {
          return s1.time.minute.compareTo(s2.time.minute);
        }

        return s1.time.hour.compareTo(s2.time.hour);
      });
    }
    return map;
  }
}
