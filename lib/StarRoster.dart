import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shift/url_constants.dart';
import 'SideMenu.dart';
import 'login.dart';
import 'model/StaffshiftRosterListResponce.dart';

class StarRoster extends StatefulWidget {

  @override
  _StarRosterState createState() => _StarRosterState();
}

class _StarRosterState extends State<StarRoster> {
  late Future<StaffshiftRosterListResponce> fetchdata;
  ScrollController _scrollController = ScrollController();
  final getStorge = GetStorage();
  bool loopFinished = false;

  late List<DateTime> _daysOfMonth;
  DateTime? _selectedDate;

  List<RosterListData> manufacturerList = [];
  String colorCode = "";

  String user_id=GetStorage().read("id");
  late final DateTime firstDayOfMonth;
  late final DateTime lastDayOfMonth;
  late final DateTime? selectedDate;
  int currentday = 0;
  int currentmonth = 0;
  int currentyear = 0;
  String? dateSelection = '';
  int indexnum=0;


  @override
  void initState() {
    super.initState();
    indexnum=0;
    DateTime now = DateTime.now();
    firstDayOfMonth = DateTime(now.year, now.month, 1);
    lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    selectedDate = firstDayOfMonth;
    currentyear = firstDayOfMonth.year;
    currentmonth = firstDayOfMonth.month;
    currentday = firstDayOfMonth.day;
    _daysOfMonth = [];
    _daysOfMonth.clear();
    getupdateddatafirst('$currentmonth', '$currentyear');
  }

  void updateManufacturerList(int indexno) {
    DateTime dd = DateTime(
        currentyear,
        currentmonth,
        manufacturerList![indexno].day!);
    setState(() {
      indexnum=indexno;
      _selectedDate = dd;
      _scrollController.animateTo(
        indexno * 60, // replace `itemWidth` with your item's width
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      currentyear = dd.year;
      currentmonth = dd.month;
      currentday = dd.day;
      DateFormat formatter2 = DateFormat('dd MMM yyyy');
      String newDateString2 = formatter2.format(dd);
      dateSelection = newDateString2;
    });
  }

  void getupdateddatafirst(String month, String year) {
    fetchdata = ProcedureApiService.fetchRouteData(user_id, month, year);
    fetchDataa();
  }

  Future<void> fetchDataa() async {
    _daysOfMonth.clear();
    StaffshiftRosterListResponce manufacturerListResponse = await fetchdata;
    late List<DateTime> _daysOfMonthss = [];
    for (int i = 0; i < manufacturerListResponse.data!.length; i++) {
      try {
        DateTime dd = DateTime(
            currentyear,
            currentmonth,
            manufacturerListResponse.data![i].day!);
        _daysOfMonthss.add(dd);
      } catch (e) {
        print('Error: ${e.toString()}');
      }

      if (i == manufacturerListResponse.data!.length - 1) {
        setState(() {
          loopFinished = true;
        });
      }
    }
    if (loopFinished) {
      setState(() {
        _daysOfMonth.addAll(_daysOfMonthss);
      });
    }
    setState(() {
      manufacturerList.clear();
      manufacturerList = manufacturerListResponse.data!;
      for (int i = 0; i < manufacturerList.length; i++) {
        if (i == 0) {
          DateTime date22 = DateTime(currentyear, currentmonth,
              int.parse(manufacturerList[i].day.toString()));
          _selectedDate = date22;
          DateFormat formatter2 = DateFormat('dd MMM yyyy');
          String newDateString2 = formatter2.format(_selectedDate!);
          dateSelection = newDateString2;
        }
      }
    });
  }


  void _generateDaysOfMonth(DateTime start, DateTime end) {
    _daysOfMonth = [];
    _daysOfMonth.clear();
    for (DateTime date = start; date.isBefore(end.add(Duration(days: 1)));
    date = date.add(Duration(days: 1))) {
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
        currentday = firstDayOfMonths.day;
        currentmonth = firstDayOfMonths.month;
        currentyear = firstDayOfMonths.year;
        _selectedDate = picked;
        _generateDaysOfMonth(firstDayOfMonths, lastDayOfMonths);
        getupdateddatafirst('$currentmonth', '$currentyear');
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
                            'Star Roaster',
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
                  height: 100,
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
             SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                             children: _daysOfMonth
                              .asMap()
                              .entries
                              .map((entry) {
                            int index = entry.key;
                            DateTime date = entry.value;
                            bool isSelected = _selectedDate != null
                                ? date == _selectedDate
                                : false;
                            return GestureDetector(
                              onTap: () {
                                updateManufacturerList(index);
                              },
                              child: Container(
                                width: 60,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Color(0xFF142247)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: isSelected
                                        ? Color(0xFF142247)
                                        : Colors.transparent,
                                    width: 4,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        DateFormat.MMM().format(date),
                                        style: TextStyle(
                                          fontFamily: 'Poppins_normal',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          color: isSelected
                                              ? Colors.white
                                              : Color(0xFF142247),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        '${date.day}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins_normal',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          color: isSelected
                                              ? Colors.white
                                              : Color(0xFF142247),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        DateFormat.E().format(date),
                                        style: TextStyle(
                                          fontFamily: 'Poppins_normal',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          color: isSelected
                                              ? Colors.white
                                              : Color(0xFF142247),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: 1,
                itemBuilder: (context, index) {
                  final location = manufacturerList[indexnum];
                  return Container(
                      width: 60,
                      decoration:
                      BoxDecoration(color: Color(0xFF142247),
                      borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                  color:Color(0xFF142247),
                  width: 4,
                  ),
                  ),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                          padding: EdgeInsets.all(10),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: location.locationData!.length,
                          itemBuilder: (context, index) {
                            final locationTime =
                            location.locationData![index];
                            return Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(// Make width match parent
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFB8B423), // Set the color to #B8B423
                                    borderRadius: BorderRadius.circular(5.0), // Adjust the border radius as needed
                                  ),
                                  child:Container(
                                    width: double.infinity, // Set the desired width// Set the desired height
                                    child: Text(
                                      locationTime.name!,
                                      style: TextStyle(
                                        fontFamily: 'Poppins_normal',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                    padding: EdgeInsets.fromLTRB(0,10.0,0,10.0),
                                    shrinkWrap: true,
                                    physics:
                                    NeverScrollableScrollPhysics(),
                                    itemCount: locationTime.locationTimes!.length,
                                    itemBuilder: (context, index) {
                                      final locationTimea = locationTime.locationTimes![index];
                                      return Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                      Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                      color: Color(0xFFB0B0B0), // Set the color to #B8B423
                                      borderRadius: BorderRadius.circular(5.0), // Adjust the border radius as needed
                                      ),
                                      child:
                                      Container(
                                      width: double.infinity, // Set the desired width
                                      child:
                                      Text(locationTimea.time!,
                                            style: TextStyle(
                                              fontFamily: 'Poppins_normal',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                      ),
                                      ),
                                            ListView.builder(
                                      padding: EdgeInsets.fromLTRB(0,1.0,0,1.0),
                                              shrinkWrap: true,
                                              physics:
                                              NeverScrollableScrollPhysics(), itemCount: locationTimea.data!.length,
                                              itemBuilder: (context, index) {
                                                final person = locationTimea.data![index];
                                                String colorCode = person.colorCode!; // Assuming person.colorCode is a string representing the color code
                                                colorCode = colorCode.replaceAll('#', '');
                                                Color color = Color(int.parse('0xFF$colorCode'));
                                                return Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                color: color, // Set the color to #B8B423
                                                borderRadius: BorderRadius.circular(5.0), // Adjust the border radius as needed
                                                ),
                                                  margin: EdgeInsets.all(1),
                                                 child:
                                                Container(
                                                width: double.infinity, // Set the desired width
                                                child: Text(
                                                      person.name!,
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins_normal',
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                      ),
                                                    ),
                                                ),
                                                ),
                                                  ],
                                                );
                                              },
                                            ),

                                        ],
                                      );
                                    },
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ProcedureApiService {
  static var client = http.Client();

  static Future<StaffshiftRosterListResponce> fetchRouteData(String userid,String month,String year) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.staff_star_roster);
    Map body = {
      'user_id': userid,
      'month':month,
      'year':year,
    };
    http.Response response =
    await http.post(url, body: jsonEncode(body), headers: headers);
    if (response.statusCode == 200) {
      return routeModelFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }




}

