import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shift/url_constants.dart';
import 'package:http/http.dart' as http;

import 'Notification.dart';
import 'SideMenu.dart';
import 'ViewPage.dart';
import 'model/StaffshiftDashboardResponce.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<StaffshiftDashboardResponce> fetchdata;

  List<UpcommingShift> upcommingshift = [];
  List<ShiftOffload> shiftoffload = [];
  List<RecentCommunications> recentcommunication = [];
  int? totalShift;
  String user_id="";

  @override
  void initState() {
    super.initState();
    user_id=GetStorage().read("id");
    getupdateddatafirst(user_id);
  }

  void grabStaffOffloadShiftGrab( String id) {
    fetchdata = OffloadShiftApi.fetchRouteData(user_id, id);
    setState(() {
      fetchDataAs(user_id);
    });
  }

  void recallbutton( String id) {
    fetchdata = RecallApi.fetchRouteData(user_id, id);
    setState(() {
      fetchDataAs(user_id);
    });
  }

  void staff_offload_shift( String id) {
    fetchdata = OffloadApi.fetchRouteData(user_id, id);
    setState(() {
      fetchDataAs(user_id);
    });
  }

  Future<void> fetchDataAs(String userId) async {
    getupdateddatafirst(userId);
  }

  void grabshift(String user_id,String id){
    late Future<StaffshiftDashboardResponce> fetchdatas;
    fetchdatas = OffloadShiftApi.fetchRouteData(user_id,id);
    getupdateddatafirst(user_id);
  }

  void grabstaffoffloadshiftgrab(String user_id,String id){
    late Future<StaffshiftDashboardResponce> fetchdatas;
    fetchdatas = OffloadShiftApi.fetchRouteData(user_id,id);
    getupdateddatafirst(user_id);
  }

  void getupdateddatafirst(String userid){
    fetchdata = ProcedureApiService.fetchRouteData(user_id);
    setState(() {
      fetchDataa();
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
                  String formattedDate = DateFormat("dd-MMM-yyyy").format(date);
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
                          Text(formattedDate,
                            style: TextStyle(
                            fontFamily: 'Poppins_normal',
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            color: Colors.white,
                          ),),
                          SizedBox(height: 5),
                          Text(
                            'Details',
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text("Location: "+""+shift.locationName.toString(),
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          SizedBox(height: 5),
                          Text("Platform: "+shift.platformName.toString(),
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          SizedBox(height: 5),
                          Text("Shift Type: "+shift.qualificationName.toString(),
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          SizedBox(height: 5),
                          Text(
                            'Availability',
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(shift.availableMsg.toString(),
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          SizedBox(height: 5),
                          Text(
                            'Offload',
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(shift.availableMsg.toString(),
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          SizedBox(height: 5),
                          Text("Start Time: "+shift.startTime.toString(),
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.white,
                            ),),
                          SizedBox(height: 5),
                          Text("End Time "+shift.endTime.toString(),
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.normal,
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
                                      shift.reminderId!,
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
                                    recallbutton(
                                      shift.reminderId!,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF066E95),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text('Recall', style: TextStyle(
                                    fontFamily: 'Poppins_normal',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),),
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
                itemCount: shiftoffload!.length, // replace with api response count
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
                            'Shift Date',
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            shiftoffload[index].shiftDate!,
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Offload Date',
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            shiftoffload[index].offloadDate!,
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Subject',
                            style: TextStyle(
                              fontFamily: 'Poppins_normal',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            shiftoffload[index].subject!,
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
                              if (shiftoffload[index].offloadShiftGrab == 1)
                                ElevatedButton(
                                  onPressed: () {
                                    grabStaffOffloadShiftGrab(
                                      shiftoffload[index].id!,
                                    );
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
                              else if (shiftoffload[index].offloadShiftGrab == 2)
                                ElevatedButton(
                                  onPressed: () {
                                    grabStaffOffloadShiftGrab(
                                      shiftoffload[index].id!,
                                    );
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
}

class ProcedureApiService {
  static var client = http.Client();

  static Future<StaffshiftDashboardResponce> fetchRouteData(
      String userid) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.staffDashboard);
    Map body = {
      'user_id': userid,
    };
    http.Response response =
    await http.post(url, body: jsonEncode(body), headers: headers);
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

  static Future<StaffshiftDashboardResponce> fetchRouteData(
      String userid,String id) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.staff_offload_shift_grab);
    Map body = {
      'user_id': userid,
      'id':id,
    };
    http.Response response =
    await http.post(url, body: jsonEncode(body), headers: headers);
    // print("Route Model Data is :........");
    // print(response.body);
    if (response.statusCode == 200) {
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
    http.Response response =
    await http.post(url, body: jsonEncode(body), headers: headers);
    // print("Route Model Data is :........");
    // print(response.body);
    if (response.statusCode == 200) {
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
    http.Response response =
    await http.post(url, body: jsonEncode(body), headers: headers);
    // print("Route Model Data is :........");
    // print(response.body);
    if (response.statusCode == 200) {
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
    http.Response response =
    await http.post(url, body: jsonEncode(body), headers: headers);
    // print("Route Model Data is :........");
    // print(response.body);
    if (response.statusCode == 200) {
      return routeModelFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }
}




