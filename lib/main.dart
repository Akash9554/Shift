


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'SplashScreen.dart';



void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Color(0xFF73CDEF)
  ));


  await GetStorage.init();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'SplashScreen',
     theme: ThemeData(
    primaryColor: Color(0xFF73CDEF),
  
    
  ),
    routes: {
      'SplashScreen': (context) => const SplashScreen(),
          },
  ));
}
