import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/models/activity.dart';
import 'package:get/get.dart';

class ActivityController extends GetxController {
  final activities = <Activity>[
    Activity(
      name: "Aktivitas 1",
      description: "Aktivitas 1",
      date: DateTime.now().subtract(const Duration(days: 3)),
      duration: const Duration(minutes: 15),
      isDone: true,
    ),
    Activity(
      name: "Aktivitas 2",
      description: "Aktivitas 2",
      date: DateTime.now().subtract(const Duration(days: 1)),
      duration: const Duration(hours: 2),
      isDone: true,
    ),
    Activity(
      name: "Aktivitas 3",
      description: "Aktivitas 3",
      date: DateTime.now(),
      duration: const Duration(minutes: 30),
      isDone: false,
    ),
    Activity(
      name: "Aktivitas 4",
      description: "Aktivitas 4",
      date: DateTime.now(),
      duration: const Duration(hours: 2, minutes: 30),
      isDone: false,
    ),
    Activity(
      name: "Aktivitas 5",
      description: "Aktivitas 5",
      date: DateTime.now().add(const Duration(days: 3)),
      duration: const Duration(minutes: 15),
      isDone: false,
    ),
    Activity(
      name: "Aktivitas 6",
      description: "Aktivitas 6",
      date: DateTime.now().add(const Duration(days: 4)),
      duration: const Duration(minutes: 15),
      isDone: false,
    ),
  ].obs;

  List<Activity> get todayActivities => activities.where(
        (a) {
          final today = DateTime.now();

          return today.year == a.date.year &&
              today.month == a.date.month &&
              today.day == a.date.day;
        },
      ).toList();

  void addActivity(Activity newActivity) {
    activities.add(newActivity);
    Get.showSnackbar(const GetSnackBar(
      duration: Duration(seconds: 5),
      icon: Icon(Icons.check, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      shouldIconPulse: false,
      backgroundColor: Colors.green,
      message: "Tambah Aktivitas Sukses!",
    ));
  }

  void deleteActivity(Activity activity) {
    activities.remove(activity);
    Get.showSnackbar(const GetSnackBar(
      duration: Duration(seconds: 5),
      icon: Icon(Icons.check, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      shouldIconPulse: false,
      backgroundColor: Colors.red,
      message: "Hapus Aktivitas Sukses!",
    ));
  }

  void editActivity(int index, Activity activity) {
    activities[index] = activity;
    Get.showSnackbar(const GetSnackBar(
      duration: Duration(seconds: 5),
      icon: Icon(Icons.check, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      shouldIconPulse: false,
      backgroundColor: Colors.green,
      message: "Edit Aktivitas Sukses!",
    ));
  }
}
