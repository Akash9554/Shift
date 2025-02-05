

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
      "type": "service_account",
      "project_id": "star-staff-rostering",
      "private_key_id": "f362291fa6f4cbf883d44f0936b921fc1bb15839",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDZr2+45gXbRzV3\nBHs7mKMI0l+QoVXLvDCo6h7K/PZCSrT6p3yMVzlS/2benGfT5pr5tftJrVe2PC9W\nEPsAmd+W57z4HzzdWhVQOxgkXge3l092NH5VDyGs5UlPKXpfn+EjUIBaTKkJmBOf\no7corXX2RqOArKm5dUmBq55TU2wR76CgGsRj0eL/LT5CnEQugNsWiNMbIPSXwEH2\noUYOS3nFTAnuUGF0oHAwmKd4SbyPB9thmC2DbRlEoI5jitfXCtap5ExwK83rwEkf\nmkkEyE9x5JXlO74A2y1QveXqWypwlSuX607oNGBGEtYJ6j2PQYhJWazwx1UT6OsI\nRbnMMDjzAgMBAAECggEABF6YpAH+ARpLUPHGlXopX551a55Jbhb/dQyKBLISMV91\nhYiCIAEKNgfJZVOHZAH/f16vRhnUJmTL4HLjzu3HxqwtJ1/dJWZPAjbFc8ltZzqC\nzlEcbhGpL+LEV3HyMmQvrTlK8kUSqY4jarNrFEZzFTfyxTzyBTZ8/LzYpzyH8U4w\nFUyNGmAnvVVB/1WJHddsu1/YHdPADU2M5x7N8HhZHTttdcxyYozqxb+xEyDJUXX6\nxh/yLlsnPb5eDfTck+RLZEWs6EQH2p77FuknkTjk6fQmsgG2oy3Bq7DDYhJRFX3U\noj1J4FiEogVKLXTIuq+pXv1tRvKQnIrjlXb6M+3qEQKBgQDvqQBSkEpbuJxkLue7\n7DSJntDVYIWxGCNexsTdlUDa5BamYamPCPHkbPmFZcETNDjAKEFvgyLERKDIb+lr\n8lWU6YtCizhVbjNxiq2IvvL3qIJqyZMgd+ftuRFaxEr+YECJCK3klzV5bToW44jE\nLaZSlArkmf92msrdglYtjQKScQKBgQDohuN9B7rhktnDfDNTWdZG/4lisccrjU/6\ns19EUhCjDE4Q5YGFEQkSGuhvdkt4K12CiarARw+LBbgBDEOdwnuZaC3/GvclEte5\nJcJU+SrYKCRzRmRIIBR1HlodbMMtK+IvJX0HI95PV1qCGBW80SKLf6L+XZ9hUpYA\nOKqgNjQrowKBgQCh1a6ZEkSUIVrCMAZeGQf1MqB0pkRBLTqdQn4n3yS3azR8UBCu\nvOyTQp9QXED/1dDIuaZORfBRNsKX9zJZqX/vGbHnUpnM3qiwcGP0pnTtlgXTVKEc\nWLvuBH3anBjEI30QzCKY7R64C3Ehia6OQwFAXCXq7q7aiXaaE+xbwA/PkQKBgA9S\n7GUOAFvjUKSYZ82DayKsroIpkyWkn3O3JH0dJ2mHYxGr/lglokJmMZE+64RU30m+\nBtm7FSQlUVYIV+Bqs7iNbBKW1VjFICBcg60T6qXqJ1TNe8hhDNgXEvtDcq1kafiP\ncOjqjTkPWbCfI7eY1Lz6wWQgCWPhjG8hTOVYDSIfAoGBAOq4xo2DpNaNJbuHP/jS\n2PXhJj0lcjY/kIJF2Tb7lVycUkq9DZjpaSwFposvXu0sny9X657rIiL5iCskR+Lp\nd2QxOIHE1mkPxUDv66BMQhUb6URPE+looJtZtOoXZ7HAeLkhOXj+ADNj9qbA7re8\nwP8BXMn9iUebuDM2yzeV3pD6\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-t7ru9@star-staff-rostering.iam.gserviceaccount.com",
      "client_id": "105132505600400332663",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-t7ru9%40star-staff-rostering.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
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

