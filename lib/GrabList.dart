import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shift/url_constants.dart';
import 'package:http/http.dart' as http;

import 'SideMenu.dart';
import 'ViewPage.dart';
import 'model/StaffshiftGrablistResponce.dart';

class GrabList extends StatefulWidget {
  @override
  _GrabListState createState() => _GrabListState();
}

class _GrabListState extends State<GrabList> {
  late Future<StaffshiftGrablistResponce> fetchdata;
  List<GrabListData> shiftoffload = [];

  @override
  void initState() {
    super.initState();
    String user_id=GetStorage().read("id");
    getUpdatedDataFirst(user_id);
  }

  void grabStaffOffloadShiftGrab(String userId, String id) {
    fetchdata = OffloadShiftApi.fetchRouteData(userId, id);
    setState(() {
      fetchDataAs(userId);
    });
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

    if (manufacturerListResponse.data != null) {
      setState(() {
        shiftoffload.clear();
        shiftoffload = manufacturerListResponse.data!;
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
              Container(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
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
                            SizedBox(height: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => MyPage(data: shiftoffload[index].mailData!,
                                      subject: shiftoffload[index].subject!, offload: shiftoffload[index].offloadShiftGrab!,id: shiftoffload[index].id!));

                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF066E95),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text('View',
                                   style: TextStyle(
                                      fontFamily: 'Poppins_normal',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                if (shiftoffload[index].offloadShiftGrab == 1)
                                  ElevatedButton(
                                    onPressed: () {
                                      grabStaffOffloadShiftGrab(
                                        shiftoffload[index].userId!,
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
                                else if (shiftoffload[index].offloadShiftGrab == 2)
                                  ElevatedButton(
                                    onPressed: () {
                                      grabStaffOffloadShiftGrab(
                                        shiftoffload[index].userId!,
                                        shiftoffload[index].id!,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF066E95),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text('You want to grab this shift',style: TextStyle(
                                      fontFamily: 'Poppins_normal',
                                      fontWeight: FontWeight.w500,
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
            ],
          ),
        ),
      ),
    );
  }
}


class ProcedureApiService {
  static var client = http.Client();

  static Future<StaffshiftGrablistResponce> fetchRouteData(
      String userid) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.staff_grab_list);
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

  static Future<StaffshiftGrablistResponce> fetchRouteData(
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



