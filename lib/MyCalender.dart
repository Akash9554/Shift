import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shift/url_constants.dart';
import 'package:table_calendar/table_calendar.dart';

import 'SideMenu.dart';
import 'login.dart';
import 'model/StaffshiftCalenderListResponce.dart';

class MyCalendars extends StatefulWidget {

  @override
  _MyCalendarsState createState() => _MyCalendarsState();
}

class _MyCalendarsState extends State<MyCalendars> {
  late Future<StaffshiftCalenderListResponce> fetchdata;
  ScrollController _scrollController = ScrollController();
  final getStorge = GetStorage();

  late List<DateTime> _daysOfMonth;
  DateTime? _selectedDate;
  List<MyCalender> manufacturerList = [];
  String? message = '';
  String? messageSec = '';
  String? dateSelection = '';
  bool loopFinished = false;
  Color colorsec=Colors.white;

  String user_id=GetStorage().read("id");
  late final DateTime firstDayOfMonth;
  late final DateTime lastDayOfMonth;
  late final DateTime? selectedDate;
  int currentday = 0;
  int currentmonth = 0;
  int currentyear = 0;
  Set<String> processedDates = Set<String>();

  @override
  void initState() {
    super.initState();
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

  void getupdateddatafirst(String month, String year) {
    EasyLoading.show(status: 'loading...');
    fetchdata = ProcedureApiService.fetchRouteData(user_id, month, year);
    fetchDataa();
  }

  Future<void> fetchDataa() async {
    _daysOfMonth.clear();
    StaffshiftCalenderListResponce manufacturerListResponse = await fetchdata;
    late List<DateTime> _daysOfMonthss = [];
    for (int i = 0; i < manufacturerListResponse.data!.length; i++) {
      try {
        DateTime dd = DateTime(
            int.parse(manufacturerListResponse.data![i].year!),
            int.parse(manufacturerListResponse.data![i].month!),
            int.parse(manufacturerListResponse.data![i].day!));
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
        _daysOfMonth=_daysOfMonthss;
      });
    }
    setState(() {
      manufacturerList.clear();
      manufacturerList = manufacturerListResponse.data!;
      if (manufacturerList.isNotEmpty) {
        for (int i = 0; i < manufacturerList.length; i++) {
          DateTime date22 = DateTime(
            int.parse(manufacturerList[i].year!),
            int.parse(manufacturerList[i].month!),
            int.parse(manufacturerList[i].day!),
          );

          DateTime currentDate = DateTime.now();
          // Compare only the year, month, and day
          if (currentDate.year == date22.year &&
              currentDate.month == date22.month &&
              currentDate.day == date22.day) {
            _selectedDate = date22;

            // Format the selected date
            DateFormat formatter2 = DateFormat('dd MMM yyyy');
            dateSelection = formatter2.format(_selectedDate!);

            // Assign message from `checkBlock`
            message = manufacturerList[i].checkBlock ?? '';

            // Handle `reminderAvailabilityData`
            List<String> reminderData =
                manufacturerList[i].reminderAvailabilityData ?? [];
            if (reminderData.isEmpty) {
              messageSec = '';
              colorsec = Colors.white;
            } else {
              String colorCode =
                  manufacturerList[i].dateBackgroundColor ?? 'FFFFFF';
              colorCode = colorCode.replaceAll('#', '');
              colorsec = Color(int.parse('0xFF$colorCode'));
              messageSec = reminderData.join(', ');
            }
          }
        }
      }
    });

  }

  void updateManufacturerList(int indexno) {
    DateTime dd = DateTime(int.parse(manufacturerList![indexno].year!),
        int.parse(manufacturerList![indexno].month!),
        int.parse(manufacturerList![indexno].day!));
    setState(() {
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
      if (!(manufacturerList[indexno].checkBlock == null)) {
        message = manufacturerList[indexno].checkBlock;
      } else {
        message = '';
      }

      List<String> reminderData = manufacturerList[indexno].reminderAvailabilityData ?? [];
      if (reminderData.isEmpty) {
        messageSec = '';
        colorsec=Colors.white;
      } else {
        String colorCode = manufacturerList[indexno].dateBackgroundColor!; // Assuming person.colorCode is a string representing the color code
        colorCode = colorCode.replaceAll('#', '');
        colorsec = Color(int.parse('0xFF$colorCode'));
        messageSec = reminderData.join(', ');
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
          color: Color(0xFF73CDEF), // set the background color here
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
                                'My Calendar',
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
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        TableCalendar(
                          calendarFormat: CalendarFormat.month,
                          onDaySelected: (selectedDate, focusedDay) {
                            int selectedIndex = _daysOfMonth.indexWhere((date) => isSameDay(date, selectedDate));
                            if (selectedIndex != -1) {
                              setState(() {
                                _selectedDate = selectedDate;
                              });
                              processedDates.clear();
                              updateManufacturerList(selectedIndex);
                            }
                          },
                          headerVisible: true,
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: const Color(0xff000000),

                            ),
                            weekendStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: const Color(0xff000000),
                            ),),
                          headerStyle: HeaderStyle(
                            titleTextStyle: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 17.0),
                            formatButtonVisible: false,
                            titleCentered: true,
                            headerMargin: EdgeInsets.all(15.0),
                            rightChevronVisible: false,
                            leftChevronVisible: false,
                            headerPadding: EdgeInsets.all(8.0),),
                          availableGestures: AvailableGestures.all,
                          availableCalendarFormats: const {
                            CalendarFormat.month: 'Month',
                          },
                          focusedDay: _daysOfMonth.first,
                          firstDay: _daysOfMonth.first,
                          lastDay: _daysOfMonth.last,
                          calendarBuilders: CalendarBuilders(
                            markerBuilder: (context, date, events) {
                              processedDates.clear();
                              String dateString = '${date.year}-${date.month}-${date.day}';
                              if (!processedDates.contains(dateString) && _isSpecialDate(date)) {
                                processedDates.add(dateString);
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF142247),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${date.day}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Poppins_normal',
                                    ),
                                  ),
                                );
                              } else {
                                if (!_isSpecialDate(date)) {
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${date.day}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'Poppins_normal',
                                        ),
                                      ),
                                    );
                                }
                              }
                            },
                          ),
                        ),


                        Padding(
                          padding: EdgeInsets.all(20),
                          child:
                          SingleChildScrollView(
                            child: Center(
                              child:
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Color(0xFF142247),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /*Padding(
                                      padding: EdgeInsets.all(10),
                                      child:
                                      Text(
                                        message!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins_normal',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),*/
                                    Container(
                                      height: 1,
                                      color: Colors.transparent,

                                    ),
                                    SizedBox(height: 8),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        dateSelection!,
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
                                      color: Colors.transparent,
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        messageSec!,
                                        style: TextStyle(
                                          color: colorsec,
                                          fontFamily: 'Poppins_normal',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      height: 1,
                                      color: Colors.transparent,
                                    ),
                                  ],
                                ),
                              ),
                            ),),
                        ),
                      ],
                    ),
                  ),
                ),
              ]
          ),
        ));
  }

  bool _isSpecialDate(DateTime date) {
    bool status = false;
    for (int i = 0; i < manufacturerList.length; i++) {
      DateTime date22 = DateTime(
        int.parse(manufacturerList[i].year!),
        int.parse(manufacturerList[i].month!),
        int.parse(manufacturerList[i].day!),
      );
      if (date.day == date22.day) {
        if (manufacturerList[i].reminderAvailabilityData==null || manufacturerList[i].reminderAvailabilityData!.isEmpty) {
          status = false;
          break;
        } else {
          status = true;
          break;
        }
      }
    }
    return status;
  }


}

class ProcedureApiService {
  static var client = http.Client();

  static Future<StaffshiftCalenderListResponce> fetchRouteData(String userid,String month,String year) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
    Uri.parse(AppUrls.baseUrl + AppUrls.staff_my_calender);
    Map body = {
      'user_id': userid,
      'month':month,
      'year':year,
    };
    http.Response response;

    response=await http.post(url, body: jsonEncode(body), headers: headers);
    EasyLoading.dismiss();
    if (response.statusCode == 200) {
      return routeModelFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

}
