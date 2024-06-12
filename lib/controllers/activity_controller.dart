import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/commons/date_time_extension.dart';
import 'package:flutter_application_uas_aktivitas/database/database_helper.dart';
import 'package:flutter_application_uas_aktivitas/models/activity.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class ActivityController extends GetxController {
  final activities = <Activity>[].obs;

  final _db = Get.find<Database>();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  List<DateTime> get uniqueDate {
    final unique = activities
        .map((e) {
          return e.date.removeTime();
        })
        .toSet()
        .toList();

    unique.sort((d1, d2) => d1.compareTo(d2));

    return unique;
  }

  Map<DateTime, List<Activity>> get activityByDate {
    final map = {for (var d in uniqueDate) d: <Activity>[]};

    for (final activity in activities) {
      map[activity.date.removeTime()]!.add(activity);
    }

    return map;
  }

  void fetchData() {
    // ignore: unused_local_variable
    final query = _db.query(activityTable).then((q) {
      final result = q.map((e) => Activity.fromMap(e)).toList();
      final doneActivities = result.where((e) => e.isDone == true).toList();
      final futureActivities = result
          .where(
              (e) => e.isDone == false && e.date.compareTo(DateTime.now()) > 0)
          .toList();
      final dueActivities = result
          .where(
              (e) => e.isDone == false && e.date.compareTo(DateTime.now()) <= 0)
          .toList();

      doneActivities.sort((d1, d2) => d1.date.compareTo(d2.date));
      futureActivities.sort((d1, d2) => d1.date.compareTo(d2.date));
      dueActivities.sort((d1, d2) => d1.date.compareTo(d2.date));

      activities.assignAll([...dueActivities, ...futureActivities, ...doneActivities]);
    });
  }

  List<Activity> get todayActivities => activities.where(
        (a) {
          final today = DateTime.now();

          return today.year == a.date.year &&
              today.month == a.date.month &&
              today.day == a.date.day;
        },
      ).toList();

  List<Activity> get dueActivities =>
      activities.where((a) => a.isDone == false && a.date.compareTo(DateTime.now()) <= 0).toList();

  void addActivity(Activity newActivity) {
    _db.insert(activityTable, newActivity.toMap()).then((_) {
      fetchData();
      Get.showSnackbar(const GetSnackBar(
        duration: Duration(seconds: 5),
        icon: Icon(Icons.check, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        shouldIconPulse: false,
        backgroundColor: Colors.green,
        message: "Tambah Aktivitas Sukses!",
      ));
    });
  }

  Activity getById(int id) {
    return activities.firstWhere((a) => a.id == id);
  }

  void checkDoneActivity(Activity activity) {
    _db
        .update(activityTable, {'isDone': 1},
            where: "id = ?", whereArgs: [activity.id])
        .then((count) {
      fetchData();
      if (count > 0) {
        Get.showSnackbar(GetSnackBar(
          duration: const Duration(seconds: 5),
          icon: const Icon(Icons.check, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          shouldIconPulse: false,
          backgroundColor: Colors.green,
          message: 'Aktivitas "${activity.name}" Telah Selesai!',
        ));
      } else {
        Get.showSnackbar(GetSnackBar(
          duration: const Duration(seconds: 5),
          icon: const Icon(Icons.check, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          shouldIconPulse: false,
          backgroundColor: Colors.red,
          message: 'Tanda Aktivitas "${activity.name}" Gagal Diubah!',
        ));
      }
    });
  }

  void deleteActivity(int id) {
    _db.delete(activityTable, where: "id = ?", whereArgs: [id]).then((count) {
      fetchData();

      if (count > 0) {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 5),
          icon: Icon(Icons.check, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          shouldIconPulse: false,
          backgroundColor: Colors.green,
          message: "Hapus Aktivitas Sukses!",
        ));
      } else {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 5),
          icon: Icon(Icons.check, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          shouldIconPulse: false,
          backgroundColor: Colors.red,
          message: "Hapus Aktivitas gagal!",
        ));
      }
    });
  }

  void editActivity(Activity activity) {
    _db.update(activityTable, activity.toMap(),
        where: "id = ?", whereArgs: [activity.id]).then((count) {
      fetchData();
      if (count > 0) {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 5),
          icon: Icon(Icons.check, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          shouldIconPulse: false,
          backgroundColor: Colors.green,
          message: "Edit Aktivitas Sukses!",
        ));
      } else {
        Get.showSnackbar(const GetSnackBar(
          duration: Duration(seconds: 5),
          icon: Icon(Icons.check, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          shouldIconPulse: false,
          backgroundColor: Colors.red,
          message: "Edit Aktivitas Gagal!",
        ));
      }
    });
  }
}
