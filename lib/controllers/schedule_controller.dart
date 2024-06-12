import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/controllers/user_controller.dart';
import 'package:flutter_application_uas_aktivitas/database/database_helper.dart';
import 'package:flutter_application_uas_aktivitas/models/schedule.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class ScheduleController extends GetxController {
  final userController = Get.find<UserController>();
  final schedules = <Schedule>[].obs;
  final _db = Get.find<Database>();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() {
    if(userController.isLogin.value == false) return;

    _db.query(scheduleTable,
        where: "userId = ?",
        whereArgs: [userController.user.value.id]).then((query) {
      schedules.assignAll(query.map((e) => Schedule.fromMap(e)).toList());
    });
  }

  List<Schedule> get todaySchedule =>
      scheduleByDay[dayFromDateTime(DateTime.now())]!;

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
    _db.insert(scheduleTable, schedule.toMap()).then((count) {
      fetchData();
      if (count > 0) {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 5),
          icon: Icon(Icons.check, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          shouldIconPulse: false,
          backgroundColor: Colors.green,
          message: "Tambah Jadwal Sukses!",
        ));
      } else {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 5),
          icon: Icon(Icons.check, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          shouldIconPulse: false,
          backgroundColor: Colors.red,
          message: "Tambah Jadwal Gagal!",
        ));
      }
    });
  }

  void editSchedule(Schedule schedule) {
    _db.update(scheduleTable, schedule.toMap(),
        where: "id = ?", whereArgs: [schedule.id]).then((count) {
      fetchData();
      if (count > 0) {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 5),
          icon: Icon(Icons.check, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          shouldIconPulse: false,
          backgroundColor: Colors.green,
          message: "Edit Jadwal Sukses!",
        ));
      } else {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 5),
          icon: Icon(Icons.check, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          shouldIconPulse: false,
          backgroundColor: Colors.red,
          message: "Edit Jadwal Gagal!",
        ));
      }
    });
  }

  void deleteSchedule(Schedule schedule) {
    _db.delete(scheduleTable, where: "id = ?", whereArgs: [schedule.id]).then(
        (count) {
      fetchData();
      if (count > 0) {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 5),
          icon: Icon(Icons.check, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          shouldIconPulse: false,
          backgroundColor: Colors.green,
          message: "Hapus Jadwal Sukses!",
        ));
      } else {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 5),
          icon: Icon(Icons.check, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          shouldIconPulse: false,
          backgroundColor: Colors.red,
          message: "Hapus Jadwal Gagal!",
        ));
      }
    });
  }

  bool checkTimeSlotInDay(Day day, TimeOfDay startTime, Duration duration,
      [int? id]) {
    final sTimeInHour =
        startTime.hour.toDouble() + (startTime.minute.toDouble() / 60);

    final durationDouble = duration.inSeconds.toDouble() / (60 * 60).toDouble();

    if (sTimeInHour + durationDouble > 24) return false;

    final eTimeInHour = sTimeInHour + durationDouble;

    final daySchedules =
        scheduleByDay[day]?.skipWhile((s) => s.id == id).map((e) {
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
