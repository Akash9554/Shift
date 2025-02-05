

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shift/GrabList.dart';
import 'package:shift/MyCalender.dart';
import 'package:shift/ShiftCount.dart';
import 'package:shift/StarRoster.dart';
import 'package:shift/url_constants.dart';
import 'Availabilitynew.dart';
import 'Dashboard.dart';
import 'Notification.dart';
import 'login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'ContactList.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;



class SideMenu extends StatelessWidget {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String userid="";
  final getstorage = GetStorage();
  late String _deviceToken = "";
  String devicetypes="1";
   SideMenu({Key? key}) : super(key: key);
  Future<void> _getDeviceToken() async {
    userid = getstorage.read("id") ?? ""; // Ensure null safety
    _deviceToken = await getAccessToken(); // Fixed incorrect assignment
    String? token = await FirebaseMessaging.instance.getToken(vapidKey: _deviceToken);
    bool isAndroid = Platform.isAndroid;
    bool isIOS = Platform.isIOS;
    if (isAndroid) {
      devicetypes = "1";
    } else if (isIOS) {
      devicetypes = "2";
    }
    //OffloadShiftApi.fetchRouteData(userid, devicetypes, token!);
  }
  Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final serviceAccountJson = {

    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // Obtain the access token
    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client
    );

    // Close the HTTP client
    client.close();

    // Return the access token
    return credentials.accessToken.data;

  }

  @override
  Widget build(BuildContext context) {
    final getStorge = GetStorage();
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sideback.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                accountName: Text(getStorge.read("name"),
                  style: TextStyle(
                  fontFamily: 'Poppins_normal',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.white,
                ),
                ),
                accountEmail: Text(getStorge.read("email")
                , style: TextStyle(
                    fontFamily: 'Poppins_normal',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.white,
                  ),),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Column(
                      children: [
                        ListTile(
                          leading: Image.asset(
                            "assets/images/icon.png",
                            width: 24,
                            height: 24,
                          ),
                          title: Text('Dashboard',
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          onTap: () {
                            Get.to(() => DashboardScreen());
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            "assets/images/icon.png",
                            width: 24, // Adjust the width to your desired size
                            height: 24, // Adjust the height to your desired size
                          ),
                          title: Text('Shift Count',
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          onTap: () {
                            Get.to(() => ShiftCount());
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            "assets/images/icon.png",
                            width: 24, // Adjust the width to your desired size
                            height: 24, // Adjust the height to your desired size
                          ),
                          title: Text('Availability',
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          onTap: () {
                            Get.to(() => MonthCalendars());
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            "assets/images/icon.png",
                            width: 24, // Adjust the width to your desired size
                            height: 24, // Adjust the height to your desired size
                          ),
                          title: Text('My Calendar',
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          onTap: () {
                            Get.to(() => MyCalendars());
                          },
                        ),
                        ListTile(

                          leading: Image.asset(
                            "assets/images/icon.png",
                            width: 24, // Adjust the width to your desired size
                            height: 24, // Adjust the height to your desired size
                          ),
                          title: Text('Star Roster',
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          onTap: () {
                            Get.to(() => StarRoster());
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            "assets/images/icon.png",
                            width: 24, // Adjust the width to your desired size
                            height: 24, // Adjust the height to your desired size
                          ),
                          title: Text('Grab',
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          onTap: () {
                              Get.to(() => GrabList());
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            "assets/images/icon.png",
                            width: 24, // Adjust the width to your desired size
                            height: 24, // Adjust the height to your desired size
                          ),
                          title: Text('Contact List',
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          onTap: () {
                            Get.to(() => ContactList());
                          },
                        ),ListTile(
                          leading: Image.asset(
                            "assets/images/icon.png",
                            width: 24, // Adjust the width to your desired size
                            height: 24, // Adjust the height to your desired size
                          ),
                          title: Text('Notification',
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          onTap: () {
                            Get.to(() => NotificationList());
                          },
                        ),
                      ],

                    ),
                    Divider(),
                    ListTile(
                      leading: Image.asset(
                        "assets/images/icon.png",
                        width: 24, // Adjust the width to your desired size
                        height: 24, // Adjust the height to your desired size
                      ),
                      title: Text('Logout',
                        style: TextStyle(
                          fontFamily: 'Poppins_normal',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white,
                        ),),
                      onTap: () {
                        getstorage.erase();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                              (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

