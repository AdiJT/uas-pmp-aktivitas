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

  void addSchedule(Schedule schedule) {
    schedules.add(schedule);
    Get.showSnackbar(const GetSnackBar(
      duration: Duration(seconds: 5),
      icon: Icon(Icons.check, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      shouldIconPulse: false,
      backgroundColor: Colors.green,
      message: "Tambah Jadwal Sukses!",
    ));
  }

  void deleteSchedule(Schedule schedule) {
    schedules.remove(schedule);
    Get.showSnackbar(const GetSnackBar(
      duration: Duration(seconds: 5),
      icon: Icon(Icons.check, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      shouldIconPulse: false,
      backgroundColor: Colors.red,
      message: "Hapus Jadwal Sukses!",
    ));
  }

  bool checkTimeSlotInDay(Day day, TimeOfDay startTime, Duration duration) {
    final sTimeInHour =
        startTime.hour.toDouble() + (startTime.minute.toDouble() / 60);

    final durationDouble = duration.inSeconds.toDouble() / (60 * 60).toDouble();

    if (sTimeInHour + durationDouble > 24) return false;

    final eTimeInHour = sTimeInHour + durationDouble;

    final daySchedules = scheduleByDay[day]?.map((e) {
      final sT = e.time.hour.toDouble() + (e.time.minute.toDouble() / 60);
      final eT = sT + (e.duration.inSeconds.toDouble() / (60 * 60).toDouble());
      return (sT, eT);
    }).toList();

    if (daySchedules == null || daySchedules.isEmpty) return true;

    if (daySchedules.any((s) => s.$1 == sTimeInHour)) return false;

    if (daySchedules.any((s) => s.$2 == eTimeInHour)) return false;

    if (daySchedules.any((s) => s.$1 < sTimeInHour && s.$2 > eTimeInHour)) {
      return false;
    }

    if (daySchedules.any((s) => s.$1 < sTimeInHour && s.$2 > eTimeInHour)) {
      return false;
    }

    if (daySchedules.any((s) => s.$1 > sTimeInHour && s.$2 < eTimeInHour)) {
      return false;
    }

    if (daySchedules.any((s) => s.$1 < sTimeInHour && s.$2 > eTimeInHour)) {
      return false;
    }

    return true;
  }
}
