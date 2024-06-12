import 'package:flutter/material.dart';
import 'package:flutter_application_uas_aktivitas/controllers/user_controller.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({
    super.key,
  });

  final controller = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.orangeAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/user.png',
                  width: 100,
                  height: 100,
                ),
                Text(
                  controller.user.value.userName,
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              onPressed: () => controller.logout(),
              label: const Text(
                "Log Out",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
              ),
            ),
          )
        ],
      ),
    );
  }
}
