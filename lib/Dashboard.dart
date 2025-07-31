import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shift/openurl.dart';
import 'package:shift/url_constants.dart';
import 'package:http/http.dart' as http;
import 'SideMenu.dart';
import 'ViewPage.dart';
import 'Notify.dart';
import 'model/Get_notice_board.dart';
import 'model/StaffshiftDashboardResponce.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'model/StaffshiftGrablistResponce.dart';

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
  String UUID="";
  void incrementCounter() {
      getupdateddatafirst(user_id);
  }

  @override
  void initState() {
    super.initState();
   user_id=GetStorage().read("id");
    fetchUserId();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getnoticeboard(user_id,this.context);
    });
    getupdateddatafirst(user_id);
   // _getDeviceToken();

  }

  Future<void> fetchUserId() async {
    String? userId = await getOneSignalUserId();
    setState(() {
      UUID = userId!;
      _getDeviceToken();
    });
  }

  Future<String?> getOneSignalUserId() async {
    return await OneSignal.User.pushSubscription.id;
  }

  Future<String?> getFCMToken() async {
    String? token;
    await FirebaseMessaging.instance.getToken().then((token1) async {
      token = token1;
    }).catchError((exception, stackTrace) async {});

    return token;
  }

  Future<void> _getDeviceToken() async {

    user_id = GetStorage().read("id") ?? ""; // Ensure null safety
    bool isAndroid = Platform.isAndroid;
    bool isIOS = Platform.isIOS;
    if (isAndroid) {
      devicetypes = "1";
    } else if (isIOS) {
      devicetypes = "2";
    }
    Updatetoken.fetchRouteData(user_id, devicetypes, UUID!);
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

  void readvertise_offload( String id,String mail_id) {
    fetchdata=RecallApi3.fetchRouteData(user_id, id,mail_id);
    fetchdata.then((response) {
      incrementCounter();
    });
  }

  Future<void> cancelbtn(String id) async {
    final response = await CancelApi.fetchRouteData(user_id, id);
    incrementCounter(); // once the cancel is done
  }

  Future<void> cancelofferbtn(String id) async {
    final response = await CancelofferApi.fetchRouteData(user_id, id);
    incrementCounter(); // once the cancel is done
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

  void getupdateddatafirst(String userid) {
    setState(() {
      fetchdata = ProcedureApiService.fetchRouteData(userid);
    });
    // if you need to do something after data is fetched, use `then` or `await`
    fetchdata.then((value) {
      fetchDataa(); // but only if this is not calling setState again
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
    try {
      final StaffshiftDashboardResponce manufacturerListResponse = await fetchdata;

      setState(() {
        // Set upcoming shift if available
        if (manufacturerListResponse.upcommingShift != null) {
          upcommingshift = manufacturerListResponse.upcommingShift!;
        }

        // Set shift offload if available
        if (manufacturerListResponse.shiftOffload != null &&
            manufacturerListResponse.shiftOffload!.isNotEmpty) {
          shiftoffload.clear();
          shiftoffload = manufacturerListResponse.shiftOffload!;
        }

        // Set recent communication if available
        if (manufacturerListResponse.recentCommunications != null &&
            manufacturerListResponse.recentCommunications!.isNotEmpty) {
          recentcommunication.clear();
          recentcommunication = manufacturerListResponse.recentCommunications!;
        }

        // Set total shift
        totalShift = manufacturerListResponse.totalShift ?? 0;
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Optional: handle error state
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
                                ),

                 if (shift.offloadShiftCheck == 2)
                  ElevatedButton(
                  onPressed: () {
                  cancelbtn(
                  shift.reminderId!
                  );
                  },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE36307),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  ),
                  ),
                  child: Text('Cancel the offload', style: TextStyle(
                  fontFamily: 'Poppins_normal',
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Colors.white,
                  ),),
                  ),
                              SizedBox(height: 5),
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

                              if(shiftoffload[index].offloadReminderStatus=="3")
                                SizedBox(height: 10),
                              if(shiftoffload[index].offloadReminderStatus=="3")
                                ElevatedButton(
                                  onPressed: () {
                                    cancelofferbtn(shiftoffload[index].id!);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFE36307),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text('Cancel Offer to Grab',
                                    style: TextStyle(
                                      fontFamily: 'Poppins_normal',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),),),
                              if(shiftoffload[index].offloadReminderStatus==  "3")
                                SizedBox(height: 10),

                              if(shiftoffload[index].offloadReminderStatus=="3")
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

class RecallApi2 {
  static var client = http.Client();

  static Future<StaffshiftGrablistResponce> fetchRouteData(
      String userid,String id,String mail_data_id) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.staff_recall_offload_shift);
    Map body = {
      'user_id': userid,
      'reminder_id':id,
      'mail_data_id':mail_data_id,
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
      return routeModelFromJsons(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class RecallApi3 {
  static var client = http.Client();

  static Future<StaffshiftDashboardResponce> fetchRouteData(
      String userid,String id,String mail_data_id) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.staff_recall_offload_shift);
    Map body = {
      'user_id': userid,
      'reminder_id':id,
      'mail_data_id':mail_data_id,
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
      String userid,String id) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.cancel_offload);
    Map body = {
      'user_id': userid,
      'reminder_id':id
    };
    http.Response response;
    EasyLoading.show(status: 'loading...');
    response=await http.post(url, body: jsonEncode(body), headers: headers);
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['errorCode'] == "0") {

       // ProcedureApiService.fetchRouteData(userid);
      }else{
        Notify.snackbar(json['errorMsg'],"");
      }
      return routeModelFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class CancelofferApi {
  static var client = http.Client();

  static Future<StaffshiftDashboardResponce> fetchRouteData(
      String userid,String id) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.cancel_offer_grab);
    Map body = {
      'user_id': userid,
      'id':id
    };
    http.Response response;
    EasyLoading.show(status: 'loading...');
    response=await http.post(url, body: jsonEncode(body), headers: headers);
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['errorCode'] == "0") {

        // ProcedureApiService.fetchRouteData(userid);
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

  static Future<StaffshiftDashboardResponce> fetchRouteData(
      BuildContext context, String userid, String reply, String notice_id) async {
    var headers = {'Content-Type': 'application/json'};
    var url = Uri.parse(AppUrls.baseUrl + AppUrls.save_notice_reply);
    Map body = {
      'user_id': userid,
      'reply': reply,
      'notice_id': notice_id,
    };

    EasyLoading.show(status: 'loading...');
    http.Response response = await http.post(url, body: jsonEncode(body), headers: headers);
    EasyLoading.dismiss();

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['errorCode'] == "0") {
        // Close all dialogs
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
      } else {
        Notify.snackbar(json['errorMsg'], "");
      }
      return routeModelFromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class NoticeBoardReminder {
  static var client = http.Client();

  static Future<StaffshiftDashboardResponce> fetchRouteData(
      BuildContext context, String userid, String notice_board_reminder) async {
    var headers = {'Content-Type': 'application/json'};
    var url = Uri.parse(AppUrls.baseUrl + AppUrls.notice_board_reminder);
    Map body = {
      'user_id': userid,
      'notice_board_reminder': notice_board_reminder,
    };

    EasyLoading.show(status: 'loading...');
    http.Response response = await http.post(url, body: jsonEncode(body), headers: headers);
    EasyLoading.dismiss();

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['errorCode'] == "0") {
        // Close all dialogs
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
      } else {
        Notify.snackbar(json['errorMsg'], "");
      }
      return routeModelFromJson(response.body);
    } else {
      throw Exception('Failed to load data');
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
    return '';
  }
}




