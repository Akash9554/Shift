import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shift/GrabList.dart';
import 'package:shift/MyCalender.dart';
import 'package:shift/ShiftCount.dart';
import 'package:shift/StarRoster.dart';

import 'Availability.dart';
import 'Dashboard.dart';
import 'Notification.dart';
import 'login.dart';

class SideMenu extends StatelessWidget {
  final getstorage = GetStorage();
   SideMenu({Key? key}) : super(key: key);

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
                  color: Colors.transparent, // Set the desired background color
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
                color: Colors.transparent, // Set background color of the container to transparent
                child: Column(
                  children: [
                    Column(
                      children: [
                        ListTile(
                          leading: Image.asset(
                            "assets/images/icon.png",
                            width: 24, // Adjust the width to your desired size
                            height: 24, // Adjust the height to your desired size
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
                            Get.to(() => MonthCalendar());
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
