import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/models/activity.dart';
import 'package:flutter_application_uas_aktivitas/models/schedule.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final activities = <Activity>[
    Activity(
      name: "Aktivitas 1",
      description: "Aktivitas 1",
      date: DateTime.now().subtract(const Duration(days: 3)),
      duration: const Duration(minutes: 15),
    ),
    Activity(
      name: "Aktivitas 2",
      description: "Aktivitas 2",
      date: DateTime.now().subtract(const Duration(days: 1)),
      duration: const Duration(hours: 2),
    ),
    Activity(
      name: "Aktivitas 3",
      description: "Aktivitas 3",
      date: DateTime.now(),
      duration: const Duration(minutes: 30),
    ),
    Activity(
      name: "Aktivitas 4",
      description: "Aktivitas 4",
      date: DateTime.now(),
      duration: const Duration(hours: 2, minutes: 30),
    ),
    Activity(
      name: "Aktivitas 5",
      description: "Aktivitas 5",
      date: DateTime.now().add(const Duration(days: 3)),
      duration: const Duration(minutes: 15),
    ),
    Activity(
      name: "Aktivitas 1",
      description: "Aktivitas 1",
      date: DateTime.now().add(const Duration(days: 4)),
      duration: const Duration(minutes: 15),
    ),
  ].obs;

  List<Activity> get todayActivities => activities.where((a) {
        final today = DateTime.now();

        return today.year == a.date.year &&
            today.month == a.date.month &&
            today.day == a.date.day;
      }).toList();

  final schedules = <Schedule>[
    Schedule(
      title: "Pengolahan Citra Digital",
      day: Day.senin,
      time: const TimeOfDay(hour: 8, minute: 0),
      duration: const Duration(hours: 2)
    ),
    Schedule(
      title: "Rekayasa Perangkat Lunak",
      day: Day.senin,
      time: const TimeOfDay(hour: 11, minute: 0),
      duration: const Duration(hours: 2)
    ),
    Schedule(
      title: "Sistem Informasi Terintegrasi",
      day: Day.senin,
      time: const TimeOfDay(hour: 13, minute: 0),
      duration: const Duration(hours: 2)
    ),

    Schedule.rest(Day.selasa),

    Schedule(
      title: "Analisis Media Sosial",
      day: Day.rabu,
      time: const TimeOfDay(hour: 10, minute: 0),
      duration: const Duration(hours: 2)
    ),
    Schedule(
      title: "Pembelajaran Mesin",
      day: Day.rabu,
      time: const TimeOfDay(hour: 13, minute: 0),
      duration: const Duration(hours: 2)
    ),

    Schedule(
      title: "Data Mining",
      day: Day.kamis,
      time: const TimeOfDay(hour: 8, minute: 0),
      duration: const Duration(hours: 2)
    ),
    Schedule(
      title: "Pemograman Multi Platform",
      day: Day.kamis,
      time: const TimeOfDay(hour: 11, minute: 0),
      duration: const Duration(hours: 2)
    ),
    Schedule(
      title: "Kriptografi",
      day: Day.senin,
      time: const TimeOfDay(hour: 13, minute: 0),
      duration: const Duration(hours: 2)
    ),

    Schedule.rest(Day.jumat),

    Schedule.rest(Day.sabtu),

    Schedule(
      title: "Gereja",
      day: Day.minggu,
      time: const TimeOfDay(hour: 7, minute: 0),
      duration: const Duration(hours: 2)
    ),
  ].obs;

  List<Schedule> get todaySchedule {
    final today = dayFromDateTime(DateTime.now());

    return schedules.where((s) => s.day == today).toList();
  }
}
