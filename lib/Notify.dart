import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Notify {
  static snackbar(String title, String msg) {
    Get.snackbar(
      title,
      msg,
      icon: Image.asset("assets/image/mainlogo.png"),
      backgroundColor: Colors.black54,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 10,
      borderWidth: 2,
      colorText: Colors.white,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
