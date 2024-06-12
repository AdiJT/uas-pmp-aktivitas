import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/database/database_helper.dart';
import 'package:flutter_application_uas_aktivitas/models/user.dart';
import 'package:flutter_application_uas_aktivitas/views/login_page.dart';
import 'package:flutter_application_uas_aktivitas/views/main_layout.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class UserController extends GetxController {
  final _db = Get.find<Database>();
  final isLogin = false.obs;
  final sharedPrefs = Get.find<SharedPreferences>();

  var user = User(userName: '', password: '').obs;

  @override
  void onInit() {
    super.onInit();

    ever(isLogin, (b) {
      if (b == true) {
        Get.offAll(const LoginPage());
      } else {
        Get.offAll(const MainLayout());
      }
    });

    var userName = sharedPrefs.getString('userName');
    var password = sharedPrefs.getString('password');

    if (userName != null && password != null) {
      login(userName, password);
    } else {
      isLogin.value = false;
    }
  }

  void register(String userName, String password) async {
    var query = await _db.query(userTable, where: 'userName = ?', whereArgs: [userName]);

    if(query.isNotEmpty) {
      Get.showSnackbar(const GetSnackBar(
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
        messageText: Text(
          "User Name Telah Digunakan!",
          style: TextStyle(color: Colors.white),
        ),
        shouldIconPulse: false,
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
      ));

      return;
    }

    final user = User(userName: userName, password : password);
    final result = await _db.insert(userTable, user.toMap());
    if(result > 0) {
      Get.showSnackbar(const GetSnackBar(
        messageText: Text(
          "Registrasi Berhasil!",
          style: TextStyle(color: Colors.white),
        ),
        shouldIconPulse: false,
        duration: Duration(seconds: 5),
        backgroundColor: Colors.green,
      ));

      login(userName, password);
    } else {
      Get.showSnackbar(const GetSnackBar(
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
        messageText: Text(
          "Registrasi Gagal!",
          style: TextStyle(color: Colors.white),
        ),
        shouldIconPulse: false,
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
      ));
    }
  }

  void login(String userName, String password) async {
    var query = await _db.query(userTable,
        where: 'userName = ? AND password = ?', whereArgs: [userName, password]);

    if (query.isNotEmpty) {
      await sharedPrefs.clear();
      sharedPrefs.setString('userName', userName);
      sharedPrefs.setString('password', password);
      user(User.fromMap(query[0]));
      isLogin.value = true;
    } else {
      Get.showSnackbar(const GetSnackBar(
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
        messageText: Text(
          "Percobaan Login Gagal!",
          style: TextStyle(color: Colors.white),
        ),
        shouldIconPulse: false,
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
      ));
    }
  }
}
