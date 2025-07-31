import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shift/url_constants.dart';
import 'package:http/http.dart' as http;
import 'Dashboard.dart';
import 'SideMenu.dart';
import 'ViewPage.dart';
import 'Notify.dart';

import 'model/StaffshiftGrablistResponce.dart';

class GrabList extends StatefulWidget {
  @override
  _GrabListState createState() => _GrabListState();
}

class _GrabListState extends State<GrabList> {
  late Future<StaffshiftGrablistResponce> fetchdata;
  List<Current> shiftoffload = [];
  List<Completed> shiftcomplted = [];
  int selectedButtonIndex = 0;
  String user_id="";
  @override
  void initState() {
    super.initState();
     user_id=GetStorage().read("id");
    getUpdatedDataFirst(user_id);
  }

  void cancelbtn(  String id) {
    fetchdata=CancelApi.fetchRouteData(user_id, id);
    getUpdatedDataFirst(user_id);
  }

  Future<void> cancelofferbtn(String id) async {
    final response = await CancelofferApi.fetchRouteData(user_id, id);
    getUpdatedDataFirst(user_id); // once the cancel is done
  }

  void readvertise_offload( String id,mail_id) {
    fetchdata=RecallApi2.fetchRouteData(user_id, id,mail_id);
    getUpdatedDataFirst(user_id);
  }


  void grabStaffOffloadShiftGrab( String id) {
    fetchdata = OffloadShiftApi.fetchRouteData(user_id, id);
    getUpdatedDataFirst(user_id);

  }

  Future<void> fetchDataAs(String userId) async {
    getUpdatedDataFirst(userId);
  }
  void getUpdatedDataFirst(String userId) {
    fetchdata = ProcedureApiService.fetchRouteData(userId);
    setState(() {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    StaffshiftGrablistResponce manufacturerListResponse = await fetchdata;
    if (manufacturerListResponse.current != null || manufacturerListResponse.completed != null ) {
      setState(() {
        shiftoffload.clear();
        shiftoffload = manufacturerListResponse.current!;
        shiftcomplted.clear();
        shiftcomplted = manufacturerListResponse.completed!;
      });
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
        child: SingleChildScrollView(
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
                          'Grabs',
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
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedButtonIndex = 0; // Change this to the index of the button you want to select.
                      });
                    },
                    style: selectedButtonIndex == 0
                        ? ElevatedButton.styleFrom(backgroundColor: Color(0xFF142247))
                        : ElevatedButton.styleFrom(backgroundColor:Color(0xFF066E95)), // If selected, set the background color to blue.
                    child: Text('Current', style: TextStyle(
                      fontFamily: 'Poppins_normal',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white,
                    )),
                  ),


                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedButtonIndex = 1; // Change this to the index of the button you want to select.
                      });
                    },
                    style: selectedButtonIndex == 1
                        ? ElevatedButton.styleFrom(backgroundColor: Color(0xFF142247))
                        : ElevatedButton.styleFrom(backgroundColor:Color(0xFF066E95)), // If selected, set the background color to blue.
                    child: Text('Completed', style: TextStyle(
                      fontFamily: 'Poppins_normal',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.white,
                    )),
                  ),

                ],
              ),
              if (selectedButtonIndex == 0)
                Container(
                  padding: EdgeInsets.all(10),

                  child:
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: shiftoffload.length,
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
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
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
                              /*Container(
                                width: 300,
                                color:Colors.white,// Set the desired width
                                child: HtmlWidget(shiftoffload[index].mailData!),
                              ),*/
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                  if(shiftoffload[index].offloadReminderStatus=="3")
                                    SizedBox(height: 10),
                                  if(shiftoffload[index].offloadReminderStatus =="3")
                                    Text(
                                      'You have applied to pick up this shift. Shifts are allocated after 24 hours. You will be notified shortly.',
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
                                          fontWeight: FontWeight.w500,
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
              if (selectedButtonIndex == 1)
                // Content for Button 2
                Container(
    padding: EdgeInsets.all(10),

    child:
    ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: shiftcomplted.length,
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
      shiftcomplted[index].shiftDate!,
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
      shiftcomplted[index].offloadDate!,
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
      shiftcomplted[index].subject!,
    style: TextStyle(
    fontFamily: 'Poppins_normal',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: Colors.white,
    ),
    ),
    SizedBox(height: 5),
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
      ),
    );
  }
}


class ProcedureApiService {
  static var client = http.Client();

  static Future<StaffshiftGrablistResponce> fetchRouteData(String userid) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.staff_grab_list);
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
      final json = jsonDecode(response.body);
      if (json['errorCode'] == "0") {

      }else{
        Notify.snackbar(json['errorMsg'],"");
      }
      return routeModelFromJsons(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class CancelApi {
  static var client = http.Client();

  static Future<StaffshiftGrablistResponce> fetchRouteData(
      String userid,String id) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.readvertise_offload);
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
        Notify.snackbar(json['errorMsg'],"");
        ProcedureApiService.fetchRouteData(userid);
      }else{
        Notify.snackbar(json['errorMsg'],"");
      }
      //  ProcedureApiService.fetchRouteData(userid);
      return routeModelFromJsons(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }
}


class OffloadShiftApi {
  static var client = http.Client();

  static Future<StaffshiftGrablistResponce> fetchRouteData(
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
    // print("Route Model Data is :........");
    // print(response.body);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['errorCode'] == "0") {
        Notify.snackbar(
            "You have applied to pick up this shift. Shifts are allocated after 24 hours. You will be notified shortly.",
            "");
      }else{
        Notify.snackbar(json['errorMsg'],"");
      }
      return routeModelFromJsons(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }
}



