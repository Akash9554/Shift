import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shift/openurl.dart';
import 'package:shift/url_constants.dart';
import 'package:http/http.dart' as http;

import 'SideMenu.dart';
import 'ViewPage.dart';
import 'Notify.dart';
import 'model/Get_notice_board.dart';
import 'model/StaffshiftDashboardResponce.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:firebase_messaging/firebase_messaging.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int counter = 0;
  final GlobalKey<NavigatorState> _dialogKey = GlobalKey<NavigatorState>();

  late Future<StaffshiftDashboardResponce> fetchdata;
  String passwordError = 'Please enter your message';
  TextEditingController emailController = TextEditingController();
  late Future<Get_notice_board_ListResponce> grouteModelToJsonss;
  String devicetypes="1";
  List<UpcommingShift> upcommingshift = [];
  List<NoticeBoardData> noticeboarddata=[];
  List<ShiftOffload> shiftoffload = [];
  List<RecentCommunications> recentcommunication = [];
  int? totalShift;
  String user_id="";
  late String _deviceToken = "";

  void incrementCounter() {
      getupdateddatafirst(user_id);
  }

  @override
  void initState() {
    super.initState();
   user_id=GetStorage().read("id");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getnoticeboard(user_id,this.context);
    });

    //_onclickdeletee(context);
    getupdateddatafirst(user_id);
    _getDeviceToken();

  }
  Future<void> _getDeviceToken() async {

    user_id = GetStorage().read("id") ?? ""; // Ensure null safety
    _deviceToken = await getAccessToken(); // Fixed incorrect assignment
    String? token = await FirebaseMessaging.instance.getToken(vapidKey: _deviceToken);
    bool isAndroid = Platform.isAndroid;
    bool isIOS = Platform.isIOS;
    if (isAndroid) {
      devicetypes = "1";
    } else if (isIOS) {
      devicetypes = "2";
    }
    Updatetoken.fetchRouteData(user_id, devicetypes, token!);
  }
  Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "star-staff-rostering",
      "private_key_id": "445177fb5e2e2670f719d02aa942af979470cdd1",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCtTtoQsAviNwpl\niWdkLhqxaYpgfZqzSCggqAHlXlangStFyUfpQiAbDFluk5dcrB1lmlGwagQrmXce\n0pF5b7hq/f9hrdjAc6xfEJXeWJUaA4iy+R6H3nr8MQHu63m23Mtw+VggieW5aWct\n9fLgO8d5LmskulRXd+fRaTZkzFwqagViDnA16Jv0FN/gwC2rWhYuOL4mnN5Mss1b\nlZ+dfBw6ezL9GLvvbQUXECQQE/EbNvZEdWa6pOfje0qyCEtRqq2sOmLoVXa98umX\nnzXkQd1wKSxlYc+QAHMzg2Ma2byIF8WwMgDzH95gRLboXVODnTR0MPjqxZOasv94\n/DCuULC/AgMBAAECggEAPqqYBFe7/FDdtAhit+FJ6qPYkvpoAXLSe7h0cw1RNSFq\nVcIp/Ajalh05i1fX7/0WZiJOboVvO5qy7ZTDYI9Ktnlgql/T1AcfqYJURsFuLKlh\neSHGbee/Pci0w8Em0j31XET1HlLum8QmuIJKD9Xd04461N2BWN11GA48ymbw3q6+\nISeTqXavVRyHEGYsHwB4Oostz413JPbzhYFedlyKeRjza8LpDlNejEZ8C+sK2AB+\nIpoW6iAFTJXB+IfEAui4vqC/bqZaVoZwbY4yTsMLBxXv41eUd5YMZQuRF5424bcw\nj/8POi0fpHIQu0PxP4g+A4K3BDeqtzyGeKWD2Q7hlQKBgQDYMekC4jpz4xgwfJfS\nt9iTNP4TjELfWUURQXpLgs3jpLYNJI5D9w5NL7UezmAjNxpOmKeXtGiQVQWQSE+j\nIiX3aug17/mVXQlVfEf04MVkIfTyTBqZixyAHz6qYH/s6I424RlFfHF52YICa8Sh\n5RiUiyu1J15VZw17Pjgo4HYkjQKBgQDNN4RTk/FMXFPVxOIzlXScTPZ/Kuw8rzUw\nAYgQksECSd1nx1QSriqKxfrYSnqL5AWZqgpoLz0RDlv9ZfAR0xeg9B/DfK9gJUni\n4Y4ffMxWBaWvFb75JLRfw/HGp/uSk8GOg+m7bx2ORI2eNo3wgLPONVs00Br979Ag\nQ4QkgwflewKBgBX/HgIZGnFoDbIBO0FJS1PO9Hrwrm0jHA/hZZwBNwmOXKeBrKfl\nnyLjU75KqSVsGdUdWw/oXyswO1yuvsuOUeaWjgHO5Mn5qVV1S6zyoaLKga2VaK9u\no/u1Mh8LqnhkQPP8eyHCw5juNHgiluMR+CpE7rGDy+lMjuaXMgeWru6RAoGBAKNF\n3mRYuozUkGbuBEKiUGri2OOIlPgbNigBr+3vtNxLRHqDHqLWK0bKCa/4YdPXEZWW\nsjz+CIn/cLUFW6Hy30PRt0vjcez+/fAjIN5wfmqah53roUu8Jj5jOYOitweBw2fO\nEDJuT4eXh00vfnKxE12nGe/E+xS6rk5dKU+baLbtAoGBAJGFU/YXf1H4b4RxKvUN\niMEnTyq0Z7//IZw7iEWlbanIfaWApmN7Y6oTe4HqOaXr/+MWaSGAKuVzo5qoDccA\nJJ4T/Mjg7jcUG+Sy/nv1MWVVQ2WbrxtlX55txEfHjuj00EsbWNYtOBX0y2RQuXD9\nm3jiAnVDTGuukGmBdE7jcn8U\n-----END PRIVATE KEY-----\n",
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

    client.close();

    return credentials.accessToken.data;

  }


  void grabStaffOffloadShiftGrab( String id) {
    fetchdata = OffloadShiftApi.fetchRouteData(user_id, id);
    fetchdata.then((response) {
      incrementCounter();
    });
  }

  void getmessagelist( String id) {
    fetchdata = OffloadShiftApi.fetchRouteData(user_id, id);
    fetchdata.then((response) {
      incrementCounter();
    });
  }


  void recallbutton( String id) {
    fetchdata=RecallApi.fetchRouteData(user_id, id);
    fetchdata.then((response) {
      incrementCounter();
    });
  }

  void cancelbtn( String id,String mail_id) {
    fetchdata=CancelApi.fetchRouteData(user_id, id,mail_id);
    fetchdata.then((response) {
      incrementCounter();
    });
  }


  void staff_offload_shift( String id) {
    fetchdata = OffloadApi.fetchRouteData(user_id, id);
    fetchdata.then((response) {
      incrementCounter();
    });
  }

  Future<void> fetchDataAs(String userId) async {
    getupdateddatafirst(userId);
  }

  void grabshift(String user_id,String id){
    late Future<StaffshiftDashboardResponce> fetchdatas;
    fetchdatas = OffloadShiftApi.fetchRouteData(user_id,id);
    fetchdatas.then((response) {
      incrementCounter();
    });
  }

  void grabstaffoffloadshiftgrab(String user_id,String id){
    late Future<StaffshiftDashboardResponce> fetchdatas;
    fetchdatas = OffloadShiftApi.fetchRouteData(user_id,id);
    fetchdatas.then((response) {
      incrementCounter();
    });
  }

  void getupdateddatafirst(String userid){
    late Future<StaffshiftDashboardResponce> fetchdatas;
    fetchdatas = ProcedureApiService.fetchRouteData(user_id);

    setState(() {
      fetchdata=fetchdatas;
      fetchDataa();
    });

  }

  void getnoticeboard(String userid,BuildContext context){
    late Future<Get_notice_board_ListResponce> fetchdatas;
    fetchdatas = Getnoticeboardlist().fetchRouteDatass(context,user_id);
    fetchdatas.then((response) {
      grouteModelToJsonss=fetchdatas;
      setState(() {
        Future<Get_notice_board_ListResponce> manufacturerListResponse = grouteModelToJsonss;
        manufacturerListResponse.then((response) {
          if (response.data != null && response.data![0].noticeBoardReply?.length==0) {
            noticeboarddata = response.data!;
            _onclickdeletee(context,userid);
          }
        });

      });

    });
  }


  Future<void> fetchDataa() async {
    StaffshiftDashboardResponce manufacturerListResponse = await fetchdata;


    if (manufacturerListResponse.upcommingShift != null) {
      setState(() {
        upcommingshift = manufacturerListResponse.upcommingShift!;
      });
    }

      if (!(manufacturerListResponse.shiftOffload!.length== null)) {
        shiftoffload.clear();
        setState(() {


          shiftoffload=manufacturerListResponse.shiftOffload!;
        });
      }

      if (!(manufacturerListResponse.recentCommunications!.length==null)){
        recentcommunication.clear();
        setState(() {
          recentcommunication=manufacturerListResponse.recentCommunications!;
        });
      }

    if (!(manufacturerListResponse.totalShift==null)){

      totalShift=manufacturerListResponse.totalShift!;
    }else{
      totalShift=0;
    }

    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Image.asset(
                'assets/images/list.png',
                width: 20,
                height: 20,
              ),
            );
          },
        ),
        centerTitle: true,
        title: Image.asset(
          'assets/images/shiftlogo.png',
          width: 100,
          height: 60,
        ),
      ),
    body: Container(
    color: Color(0xFF73CDEF), // set the background color here
    child:
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF142247),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Color(0xFF142247),
                      width: 4,
                    ),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shift Count',
                        style: TextStyle(
                          fontFamily: 'Poppins_normal',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        '$totalShift',
                        style: TextStyle(
                          fontFamily: 'Poppins_normal',
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                'Upcoming Shifts',
                style: TextStyle(
                  fontFamily: 'Poppins_normal',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: upcommingshift.length,
                itemBuilder: (context, index) {
                  UpcommingShift shift = upcommingshift[index];
                  String inputDate = upcommingshift[index].slotDate!;
                  DateTime date = DateTime.parse(inputDate);
                  String formattedDate = DateFormat("EEEE dd-MMM-yyyy").format(date);
                  return Card(
                    child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF142247),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Color(0xFF142247),
                            width: 4,
                          ),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date: '+formattedDate,
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text("Start Time: "+shift.startTime.toString(),
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          SizedBox(height: 5),
                          Text("End Time "+shift.endTime.toString(),
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          SizedBox(height: 10),

                          Text("Location: "+""+shift.locationName.toString(),
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          SizedBox(height: 5),
                          Text("Platform: "+shift.platformName.toString(),
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          SizedBox(height: 5),
                          Text("Shift Type: "+shift.qualificationName.toString(),
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          SizedBox(height: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (shift.offloadShiftCheck == 1)
                                ElevatedButton(
                                  onPressed: () {
                                    staff_offload_shift(
                                      shift.id!
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF066E95),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text('Offload Shift',
                                    style: TextStyle(
                                      fontFamily: 'Poppins_normal',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),),
                                )
                              else if (shift.offloadShiftCheck == 2)
                                ElevatedButton(
                                  onPressed: () {
                                    recallbutton(shift.id!,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFE36307),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text('Shift Offload Pending', style: TextStyle(
                                    fontFamily: 'Poppins_normal',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),),
                                ),
                              if (shift.offloadShiftCheck == 2)
                  ElevatedButton(
                  onPressed: () {
                  cancelbtn(
                  shift.reminderId!,shift.id!
                  );
                  },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE36307),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  ),
                  ),
                  child: Text('Cancel Offload', style: TextStyle(
                  fontFamily: 'Poppins_normal',
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Colors.white,
                  ),),
                  ),
                              SizedBox(height: 5),
                              if (shift.offloadShiftCheck == 2)
                                Text(
                                  'Your shift is now up for grabs, you will be notified if it is successfully offloaded, until then the shift is still yours.',
                                  style: TextStyle(
                                    fontFamily: 'Poppins_normal',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.start,
                                ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                'Shifts Offload',
                style: TextStyle(
                  fontFamily: 'Poppins_normal',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: shiftoffload!.length,
                itemBuilder: (context, index) {
                  String inputDate = shiftoffload[index].shiftDate!;
                  DateTime date = DateFormat("dd-MMM-yyyy").parse(inputDate);
                  String formattedDate = DateFormat("EEEE dd-MMM-yyyy").format(date);
                  return Card(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF142247),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Color(0xFF142247),
                          width: 4,
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      if (shiftoffload[index].userDetail != null && shiftoffload[index].userDetail!.isNotEmpty)
                      Text(
                      'Staff : ' + " " + shiftoffload[index].userDetail![0].name! + " " +
            shiftoffload[index].userDetail![0].surname!,
        style: TextStyle(
          fontFamily: 'Poppins_normal',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
                          SizedBox(height: 5),
                          Text(
                            'Shift Date : '+" "+formattedDate!,
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Shift Details : "+shiftoffload[index].locationName!+"-"+shiftoffload[index].platformName!,
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          /*Container(
                            // Set the desired height
                            color:Colors.white,// Set the desired width
                            child: HtmlWidget(shiftoffload[index].mailData!),
                          ),*/
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(() => MyPage(data: shiftoffload[index].mailData!,
                                      subject: shiftoffload[index].subject!, offload: shiftoffload[index].offloadShiftGrab!, id: shiftoffload[index].id!));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF066E95),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text('View', style: TextStyle(
                                  fontFamily: 'Poppins_normal',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),),
                              ),
                              SizedBox(height: 10),
                              if(shiftoffload[index].offloadReminderStatus!="")
                                ElevatedButton(
                                  onPressed: () {
                                   // cancelbtn(shiftoffload[index].id!);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFE36307),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text('Shift Allocation Pending',
                                    style: TextStyle(
                                      fontFamily: 'Poppins_normal',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),),),
                              if(shiftoffload[index].offloadReminderStatus!="")
                                SizedBox(height: 10),
                              if(shiftoffload[index].offloadReminderStatus!="")
                                ElevatedButton(
                                  onPressed: () {
                                     cancelbtn(shiftoffload[index].reminderId!,shiftoffload[index].id!);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFE36307),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text('Cancel Offload',
                                    style: TextStyle(
                                      fontFamily: 'Poppins_normal',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),),),
                              if(shiftoffload[index].offloadReminderStatus!="")
                                SizedBox(height: 10),

                              if(shiftoffload[index].offloadReminderStatus!="")
                                Text('You have applied to pick up this shift. Shifts are allocated after 24 hours. You will be notified shortly.',
                                  style: TextStyle(
                                    fontFamily: 'Poppins_normal',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              if (shiftoffload[index].offloadShiftGrab.toString() == "1")
                                ElevatedButton(
                                  onPressed: () {
                                    grabStaffOffloadShiftGrab(shiftoffload[index].id!);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF066E95),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text('You want to grab this shift',
                                    style: TextStyle(
                                      fontFamily: 'Poppins_normal',
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),),
                                )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                'Recent Communications',
                style: TextStyle(
                  fontFamily: 'Poppins_normal',
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: recentcommunication!.length, // replace with api response count
                itemBuilder: (context, index) {
                  return Card(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF142247),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Color(0xFF142247),
                          width: 4,
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(DateFormat('dd-MMM-yy').format(DateTime.parse(recentcommunication[index].createdAt!)),
                           style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          Text(
                            'Subject',
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          Text(recentcommunication[index].subject!,
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          Text(
                            'Message',
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          Text(recentcommunication[index].message!,
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    )
    );
  }


  _onclickdeletee(BuildContext context,String user_id) async {
    try {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          key:_dialogKey,
          backgroundColor: Color(0xFF142247),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Notice Board',
                    style: TextStyle(
                      fontFamily: 'Poppins_normal',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color:  Color(0xFF142247),
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.all(10.0),
                  child: Column(
                    children: noticeboarddata
                        .where((item) => item.noticeBoardReply!.isEmpty)
                        .map((item) {
                      return NoticeItem(
                        title: item.subject!,
                        message: item.message!,
                        doc:item.image!,
                        notice_id: item.id!,
                        user_id:user_id,
                        notice_board_reminder:item.id!,

                      );
                    }).toList(),

                  ),
                ),
              ],
            ),
          ),
        ),
      ).then((value) {
        _dialogKey.currentState?.pop();
      });
    } catch (e) {
      print('Error in _onclickdeletee: $e');
    }
  }
}

class ProcedureApiService {
  static var client = http.Client();

  static Future<StaffshiftDashboardResponce> fetchRouteData(String userid) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.staffDashboard);
    Map body = {
      'user_id': userid,
    };
    http.Response response;
    EasyLoading.show(status: 'loading...');
    response=await http.post(url, body: jsonEncode(body), headers: headers);
    EasyLoading.dismiss();
    // print("Route Model Data is :........");
    // print(response.body);
    if (response.statusCode == 200) {
      return routeModelFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class OffloadShiftApi {
  static var client = http.Client();

  static Future<StaffshiftDashboardResponce> fetchRouteData(String userid,String id) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.staff_offload_shift_grab);
    Map body = {
      'user_id': userid,
      'id':id,
    };
    http.Response response;
    EasyLoading.show(status: 'loading...');
    response=await http.post(url, body: jsonEncode(body), headers: headers);
    EasyLoading.dismiss();
    // print("Route Model Data is :........");
    // print(response.body);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['errorCode'] == "0") {
        ProcedureApiService.fetchRouteData(userid);
        Notify.snackbar("You have applied to pick up this shift. Shifts are allocated after 24 hours. You will be notified shortly.", "");
      } else{
        Notify.snackbar(""+json['errorMsg'],"");
      }
      return routeModelFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class Staffoffloadshiftgrab {
  static var client = http.Client();

  static Future<StaffshiftDashboardResponce> fetchRouteData(
      String userid,String id) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.staff_offload_shift_grab);
    Map body = {
      'user_id': userid,
      'id':id,
    };
    http.Response response;
    EasyLoading.show(status: 'loading...');
    response=await http.post(url, body: jsonEncode(body), headers: headers);
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['errorCode'] == "0") {
        Notify.snackbar(
            "You have applied to pick up this shift. Shifts are allocated after 24 hours. You will be notified shortly.",
            "");
        ProcedureApiService.fetchRouteData(userid);
      }else{
        Notify.snackbar(json['errorMsg'],"");
      }
      return routeModelFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class RecallApi {
  static var client = http.Client();

  static Future<StaffshiftDashboardResponce> fetchRouteData(
      String userid,String id) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.staff_recall_offload_shift);
    Map body = {
      'user_id': userid,
      'reminder_id':id,
    };
    http.Response response;
    EasyLoading.show(status: 'loading...');
    response=await http.post(url, body: jsonEncode(body), headers: headers);
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['errorCode'] == "0") {
        ProcedureApiService.fetchRouteData(userid);
      }else{
        Notify.snackbar(json['errorMsg'],"");
      }
      return routeModelFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class CancelApi {
  static var client = http.Client();

  static Future<StaffshiftDashboardResponce> fetchRouteData(
      String userid,String id,String mail_id) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.cancel_offload);
    Map body = {
      'user_id': userid,
      'reminder_id':id,
      'mail_id':mail_id,
    };
    http.Response response;
    EasyLoading.show(status: 'loading...');
    response=await http.post(url, body: jsonEncode(body), headers: headers);
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['errorCode'] == "0") {
        ProcedureApiService.fetchRouteData(userid);
      }else{
        Notify.snackbar(json['errorMsg'],"");
      }
      return routeModelFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }
}


class OffloadApi {
  static var client = http.Client();

  static Future<StaffshiftDashboardResponce> fetchRouteData(
      String userid,String id) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.staff_offload_shift);
    Map body = {
      'user_id': userid,
      'reminder_id':id,

    };
   // Call the provided function to show loading indicator
    http.Response response ;

    EasyLoading.show(status: 'loading...');
    response=await http.post(url, body: jsonEncode(body), headers: headers);
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['errorCode'] == "0") {
        ProcedureApiService.fetchRouteData(userid);
      }else{
        Notify.snackbar(json['errorMsg'],"");
      }
      return routeModelFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

}

class Getnoticeboardlist {
  static var client = http.Client();
   Future<Get_notice_board_ListResponce> fetchRouteDatass(BuildContext context,String userid) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.get_notice_board);
    Map body = {
      'user_id': userid
    };
    http.Response response;
    EasyLoading.show(status: 'loading...');
    response=await http.post(url, body: jsonEncode(body), headers: headers);
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      return grouteModelFromJson(response.body);

    } else {
      throw Exception('Failed to load album');
    }
  }
}

class Savereply {
  static var client = http.Client();

  static Future<StaffshiftDashboardResponce> fetchRouteData(BuildContext context,String userid,String reply,String notice_id) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.save_notice_reply);
    Map body = {
      'user_id': userid,
      'reply':reply,
      'notice_id':notice_id,

    };
    // Call the provided function to show loading indicator
    http.Response response ;

    EasyLoading.show(status: 'loading...');
    response=await http.post(url, body: jsonEncode(body), headers: headers);
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['errorCode'] == "0") {
        Navigator.of(context).pop();
      }else{
        Notify.snackbar(json['errorMsg'],"");
      }
      return routeModelFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

}

class NoticeBoardReminder {
  static var client = http.Client();

  static Future<StaffshiftDashboardResponce> fetchRouteData(BuildContext context,String userid,String notice_board_reminder) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.notice_board_reminder);
    Map body = {
      'user_id': userid,
      'notice_board_reminder':notice_board_reminder,
    };
    // Call the provided function to show loading indicator
    http.Response response ;

    EasyLoading.show(status: 'loading...');
    response=await http.post(url, body: jsonEncode(body), headers: headers);
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['errorCode'] == "0") {
        Navigator.of(context).pop();
      }else{
        Notify.snackbar(json['errorMsg'],"");
      }
      return routeModelFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

}




class NoticeItem extends StatelessWidget {
  final String title;
  final String message;
  final String doc;
  final String notice_id;
  final String user_id;
  final String notice_board_reminder;



  const NoticeItem({Key? key, required this.title, required this.message,required this.doc,required this.notice_id,required this.user_id,required this.notice_board_reminder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _textFieldController = TextEditingController();
    return ListTile(
      tileColor: Color(0xFF142247),
      title: Text(title,style: TextStyle(
        fontFamily: 'Poppins_normal',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Colors.white,
      ),),
      subtitle: Text(message,style: TextStyle(
        fontFamily: 'Poppins_normal',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Colors.white,
      ),),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xFF142247),
              title: Text(title,style: TextStyle(
                fontFamily: 'Poppins_normal',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.white,
              ),),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(message,style:
                  TextStyle(
                    fontFamily: 'Poppins_normal',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.white,
                  ),),
                  SizedBox(height: 10),
                  if(doc.isNotEmpty)
                  ElevatedButton(
                      onPressed: () async {
                        OpenUrl.openUrl( doc);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF066E95),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('View Document',
                      style: TextStyle(
                        fontFamily: 'Poppins_normal',
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.white,
                      ),),
                  ),
                  if(doc.isNotEmpty)
                  SizedBox(height: 10),

                  TextField(
                    style: TextStyle(color: Colors.white, fontFamily: 'Poppins_normal'),
                    controller: _textFieldController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),

                ],
              ),
              actions: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        String enteredText = _textFieldController.text;
                        Savereply.fetchRouteData(context,user_id, enteredText, notice_id);

                      },
            style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF066E95),
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            ),
            ),
                      child: Text('I have read and acknowledge this information',
                        style: TextStyle(
                          fontFamily: 'Poppins_normal',
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.white,
                        ),),
                    ),
                    SizedBox(height: 8), // Add some space between buttons
                    ElevatedButton(
                      onPressed: () {
                        NoticeBoardReminder.fetchRouteData(context,user_id, notice_board_reminder);
                      },
            style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF066E95),
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            ),
            ),
                      child: Text('Remind me to read next time',
                        style: TextStyle(
                        fontFamily: 'Poppins_normal',
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.white,
                      ),),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
class Updatetoken {
  static var client = http.Client();

  static Future<String> fetchRouteData(
      String userid,String devicetype,String devicetoken) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.update_device_token);
    Map body = {
      'user_id': userid,
      'device_type':devicetype,
      'device_token':devicetoken,
    };
    http.Response response;
    response=await http.post(url, body: jsonEncode(body), headers: headers);

    // print("Route Model Data is :........");
    // print(response.body);
    //  if (response.statusCode == 200) {
    //  Notify.snackbar("Grab Success", "");
    //  return routeModelFromJson(response.body);
    // } else {
    // throw Exception('Failed to load album');
    return '';
  }
}




