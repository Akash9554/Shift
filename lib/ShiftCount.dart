import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shift/url_constants.dart';
import 'SideMenu.dart';
import 'package:http/http.dart' as http;
import 'model/TotalShiftResponce.dart';

class ShiftCount extends StatefulWidget {

  @override
  _ShiftCountState createState() => _ShiftCountState();
}

class _ShiftCountState extends State<ShiftCount> {
  late Future<TotalShiftResponce> fetchData;
  final getStorage = GetStorage();
  late List<DateTime> _daysOfMonth;
  DateTime? _selectedDate;
  String user_id = GetStorage().read("id");
  late DateTime firstDayOfMonth;
  late DateTime lastDayOfMonth;
  late DateTime? selectedDate;
  int currentDay = 0;
  int currentMonth = 0;
  int currentYear = 0;
  String shiftcount="";

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    firstDayOfMonth = DateTime(now.year, now.month, 1);
    lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    selectedDate = firstDayOfMonth;
    currentYear = firstDayOfMonth.year;
    currentMonth = firstDayOfMonth.month;
    String formattedMonth = currentMonth.toString().padLeft(2, '0');
    currentMonth = int.parse(formattedMonth);

    currentDay = firstDayOfMonth.day;
    _daysOfMonth = [];
    _daysOfMonth.clear();
    getUpdatedDataFirst('$formattedMonth', '$currentYear');
  }

  void getUpdatedDataFirst(String month, String year) {
    fetchData = ProcedureApiServicea.fetchRouteData(user_id, month, year);
    fetchDataa();
  }

  Future<void> fetchDataa() async {
    TotalShiftResponce shiftResponse = await fetchData;
    setState(() {
      shiftcount = shiftResponse.totalShiftCount.toString();
    });
  }

  void _generateDaysOfMonth(DateTime start, DateTime end) {
    _daysOfMonth = [];
    _daysOfMonth.clear();
    for (DateTime date = start; date.isBefore(end.add(Duration(days: 1))); date = date.add(Duration(days: 1))) {
      _daysOfMonth.add(date);
    }
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: firstDayOfMonth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      DateTime now = picked;

      DateTime firstDayOfMonths = DateTime(now.year, now.month, 1);
      DateTime lastDayOfMonths = DateTime(now.year, now.month + 1, 0);
      setState(() {
        currentDay = firstDayOfMonths.day;
        currentMonth = firstDayOfMonths.month;
        String formattedMonth = currentMonth.toString().padLeft(2, '0');
        currentMonth = int.parse(formattedMonth);
        currentYear = firstDayOfMonths.year;
        _selectedDate = picked;
        _generateDaysOfMonth(firstDayOfMonths, lastDayOfMonths);
        getUpdatedDataFirst('$formattedMonth', '$currentYear');
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
        color: Color(0xFF73CDEF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
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
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  child: Row(
                    children: [
                      Spacer(),
                      IconButton(
                        onPressed: () => _showDatePicker(context),
                        icon: Icon(
                          Icons.calendar_month_outlined,
                          size: 20,
                          color: Colors.black,
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Container(
              margin: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF142247),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Total Shift Count',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins_normal',
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 1,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        shiftcount!,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins_normal',
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 1,
                      color: Colors.white,
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
class ProcedureApiServicea {
  static var client = http.Client();

  static Future<TotalShiftResponce> fetchRouteData(String userid,String month,String year) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.staffShiftCount);
    Map body = {
      'user_id': userid,
      'month':month,
      'year':year,
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