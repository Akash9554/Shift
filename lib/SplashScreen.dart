import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shift/SideMenu.dart';
import 'dart:async';
import 'Dashboard.dart';
import 'ProductList.dart';
import 'login.dart';
import 'dart:io';



class SplashScreen extends StatefulWidget {
   const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _deviceToken = "";
  String devicetypes="";
  final getstorage=GetStorage();



  @override
  void initState() {
    super.initState();


    Future.delayed(Duration(milliseconds: 3000), () {
      checkLoggedInUser();
    }
    );
  }
  void checkLoggedInUser() {
    if (getstorage.read("id") == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
   // initializeFirebaseMessaging();
    bool isAndroid = Platform.isAndroid;
    bool isIOS = Platform.isIOS;
    if(isAndroid){
      devicetypes="1";
    }else if(isIOS){
      devicetypes="2";
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(

          children: [
            Image.asset(
              'assets/images/back.png', // Background image
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),

            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                'assets/images/right.png', // Icon 1 on right side top corner
                height: 150,
                width: 50,
              ),
            ),
            Positioned(
              top: 250,
              left: 0,
              child: Image.asset(
                'assets/images/left.png', // Icon 2 on left side corner
                height: 200,
                width: 40,
              ),
            ),
            Positioned(
              top: 120,
              left: 30,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/logosa.png', // Logo at the center
                  height: 250,
                  width: 250,
                ),
              ),
            ),
            Image.asset(
              'assets/images/bottomss.png', // Background image
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
