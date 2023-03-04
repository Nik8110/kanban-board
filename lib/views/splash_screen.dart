import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanban_board_app/views/dashboard_screen.dart';

import 'auth/loginpage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, required this.uid});
  final String uid;
  @override
  Widget build(BuildContext context) {
    initialize();
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            Hero(
              tag: "logo",
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(500)),
                child: Container(
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(500)),
                  child: const Padding(
                    padding: EdgeInsets.all(45),
                    child: Text(
                      "Kanban Board",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Text(
              "Kanban Board",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const Text(
              "Maintain task simply",
              style: TextStyle(
                  fontSize: 14, color: Colors.white, letterSpacing: 4),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  initialize() async {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (uid.isEmpty) {
          Get.off(duration: const Duration(seconds: 1), const LoginScreen());
        } else {
          Get.off(
              duration: const Duration(seconds: 1), const DashboardScreen());
        }
      },
    );
  }
}
