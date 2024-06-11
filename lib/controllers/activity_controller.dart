import 'package:flutter/material.dart';
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

  void fetchData() {
    // ignore: unused_local_variable
    final query = _db.query(activityTable, orderBy: 'id').then((q) {
      activities.assignAll(q.map((e) => Activity.fromMap(e)).toList());
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
    activity.isDone = true;
    editActivity(activity);
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
      if(count > 0) {
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
