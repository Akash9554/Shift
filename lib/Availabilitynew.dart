import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shift/url_constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'Notify.dart';
import 'SideMenu.dart';
import 'StaffAvailability.dart';
import 'StaffVisibilityApiService.dart';
import 'package:http/http.dart' as http;

class MonthCalendars extends StatefulWidget {

  @override
  _MonthCalendarsState createState() => _MonthCalendarsState();
}

class _MonthCalendarsState extends State<MonthCalendars> {
  late Future<StaffAvailability> fetchdata;
  TextEditingController _textControllernotes = TextEditingController();
  final getStorge = GetStorage();
  late List<DateTime> _daysOfMonth;
  DateTime? _selectedDate;
  TextEditingController _textEditingController = TextEditingController(
      text: "0");
  TextEditingController _textEditingControllermx = TextEditingController(
      text: "0");

  String _selectedValue = 'Yes';
  List<String> _options = [ 'Yes', 'No'];

  List<StaffData> manufacturerList = [];
  Map<DateTime, bool> specialDateMap = {};
  String daytext = "";
  String nighttext = "";
  String aftertext = "";
  String cutOffDateText = 'Cut off Date for May is Wednesday, 19 April';
  String resetbtntext = 'Re-set Available for the month';
  String save_availability = "Save Availability";
  String entire_month_unavailable = "1";
  String? notes = '';
  String? message = '';
  String? dateSelection = '';
  bool _isAvalabilityChecked = true;
  bool _isNightAvalabilityChecked = true;
  String _isAvalabilityCheckedStatus = "1";
  String _isNightAvalabilityCheckedstatus = "1";
  bool _isAfterNoonAvalabilityChecked = true;
  String _isAfterNoonAvalabilityCheckedStatus="1";
  bool loopFinished = false;
  String user_id = GetStorage().read("id");
  late StaffAvailability manufacturerListResponse;
  Set<String> processedDates = Set<String>();
  late final DateTime firstDayOfMonth;
  late final DateTime lastDayOfMonth;
  late final DateTime focusdeofMonth;
  late final DateTime? selectedDate;
  int currentday = 0;
  int currentmonth = 0;
  int currentyear = 0;
  bool start=false;
  int b=0;
  late final DateTime dayofmonth;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    dayofmonth=now;
    firstDayOfMonth = DateTime(now.year, now.month, 1);
    lastDayOfMonth = DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1));
    focusdeofMonth = DateTime(now.year, now.month, 1);
    selectedDate = firstDayOfMonth;
    currentyear = focusdeofMonth.year;
    currentmonth = focusdeofMonth.month;
    currentday = focusdeofMonth.day;
    _daysOfMonth = [];
    _daysOfMonth.clear();
    getupdateddatafirst('$currentmonth', '$currentyear');
  }

  void getupdateddatafirst(String month, String year) {
    fetchdata = ProcedureApiService.fetchRouteData(user_id, month, year);
    fetchDataa();
  }

  Future<void> fetchDataa() async {
    processedDates.clear();
    specialDateMap.clear();
    manufacturerListResponse = await fetchdata;
    setState(() {
      manufacturerList.clear();
      manufacturerList = manufacturerListResponse.data!;
    });

    List<DateTime> _daysOfMonthss = manufacturerListResponse.data!.map((item) {
      try {
        return DateTime(
          int.parse(item.year!),
          int.parse(item.month!),
          item.date!,
        );
      } catch (e) {
        print('Error: ${e.toString()}');
        return DateTime.now();
      }
    }).toList();

    setState(() {
      loopFinished = true;
      _daysOfMonth.clear();
      _daysOfMonth.addAll(_daysOfMonthss);

      if (manufacturerListResponse.usersUnavailabilityFullmonth == null) {
        resetbtntext = "Entirely unavailable for the month";
        save_availability = "Save Availability";
        entire_month_unavailable = "1";
      } else {
        entire_month_unavailable = "0";
        resetbtntext = "Re-set Available for the month";
        save_availability = "Save Individual Date Available";
      }

      var otherDetail = manufacturerListResponse.calenderOtherDetail;
      if (otherDetail != null) {
        notes = otherDetail.note ?? '';
        _textControllernotes.text = notes!;
        _textEditingController.text = otherDetail.erp ?? "0";
        _textEditingControllermx.text = otherDetail.max ?? "0";
        int samf = int.tryParse(otherDetail.samfs ?? '0') ?? 0;
        _selectedValue = samf == 1 ? "Yes" : "No";
      } else {
        _textControllernotes.text = "";
        _textEditingController.text = "0";
        _textEditingControllermx.text = "0";
        _selectedValue = "Yes";
      }

      cutOffDateText = manufacturerListResponse.calendeMsg!;
    });

    for (int a = 0; a < manufacturerList.length; a++) {
      if (dayofmonth.day == manufacturerList[a].date) {
        DateTime date22 = DateTime(
          int.parse(manufacturerList[a].year!),
          int.parse(manufacturerList[a].month!),
          manufacturerList[a].date!,
        );
        setState(() {
          b = a;
          _selectedDate = date22;
          message = manufacturerList[b].message ?? '';
          var data = manufacturerList[b].datedata?.isNotEmpty == true ? manufacturerList[b].datedata![0] : null;
          _isAvalabilityChecked = data?.dayUnavailable == "0";
          daytext = _isAvalabilityChecked ? "Day available" : "Day Unavailable";
          _isAfterNoonAvalabilityChecked = data?.afternoonUnavailable == "0";
          aftertext = _isAfterNoonAvalabilityChecked ? "Afternoon available" : "Afternoon Unavailable";
          _isNightAvalabilityChecked = data?.nightUnavailable == "0";
          nighttext = _isNightAvalabilityChecked ? "Night available" : "Night Unavailable";
        });
        break;
      }
    }
  }

  void updateManufacturerList(int indexno) {
    DateTime dd = DateTime(int.parse(manufacturerList![indexno].year!),
        int.parse(manufacturerList![indexno].month!),
        manufacturerList![indexno].date!);
    setState(() {
      _selectedDate = dd;
      currentyear = dd.year;
      currentmonth = dd.month;
      currentday = dd.day;
      DateFormat formatter2 = DateFormat('dd MMM yyyy');
      String newDateString2 = formatter2.format(dd);
      dateSelection = newDateString2;


      if (!(manufacturerList[indexno].message == null)) {
        message = manufacturerList[indexno].message;
      } else {
        message = '';
      }
      if (manufacturerListResponse.usersUnavailabilityFullmonth != null) {
        if (!(manufacturerList[indexno].datedata?.length == 0)) {
          String ? day = manufacturerList[indexno].datedata?[0].dayUnavailable;
          if (day == "0") {
            _isAvalabilityChecked = true;
            daytext = "Day available";
          } else {
            _isAvalabilityChecked = false;
            daytext = "Day available";
          }
          String ? after = manufacturerList[indexno].datedata?[0].afternoonUnavailable;
          if (after == "0") {
            _isAfterNoonAvalabilityChecked = true;
            aftertext = "Afternoon available";
          } else {
            _isAfterNoonAvalabilityChecked = false;
            aftertext = "Afternoon available";
          }
          String ? night = manufacturerList[indexno].datedata?[0]
              .nightUnavailable;
          if (night == "0") {
            _isNightAvalabilityChecked = true;
            nighttext = "Night available";
          } else {
            _isNightAvalabilityChecked = false;
            nighttext = "Night available";
          }
        } else {
          daytext = "Day available";
          nighttext = "Night available";
          aftertext = "Afternoon available";

          _isAvalabilityChecked = false;
          _isNightAvalabilityChecked = false;
          _isAfterNoonAvalabilityChecked = false;
        }
      }
      else {
        if (!(manufacturerList[indexno].datedata?.length == 0)) {
          String ? day = manufacturerList[indexno].datedata?[0].dayUnavailable;
          if (day == "1") {
            _isAvalabilityChecked = true;
            daytext = "Day Unavailable";
          } else {
            _isAvalabilityChecked = false;
            daytext = "Day Unavailable";
          }
          String ? after = manufacturerList[indexno].datedata?[0].afternoonUnavailable;
          if (after == "1") {
            _isAfterNoonAvalabilityChecked = true;
            aftertext = "Afternoon Unavailable";
          } else {
            _isAfterNoonAvalabilityChecked = false;
            aftertext = "Afternoon Unavailable";
          }
          String ? night = manufacturerList[indexno].datedata?[0]
              .nightUnavailable;
          if (night == "1") {
            _isNightAvalabilityChecked = true;
            nighttext = "Night Unavailable";
          } else {
            _isNightAvalabilityChecked = false;
            nighttext = "Night Unavailable";
          }
        } else {
          daytext = "Day Unavailable";
          nighttext = "Night Unavailable";
          aftertext = "Afternoon Unavailable";
          _isAvalabilityChecked = false;
          _isNightAvalabilityChecked = false;
          _isAfterNoonAvalabilityChecked = false;
        }
      }
    });
  }


  void _showDatePicker(BuildContext context,DateTime dateTime) async {
    processedDates.clear();
    specialDateMap.clear();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateTime ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      DateTime now = picked;

      setState(() {
        currentday = now.day;
        currentmonth = now.month;
        currentyear = now.year;
        _selectedDate = now;
        //  _generateDaysOfMonth(firstDayOfMonths,lastDayOfMonths);
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
                  width: 25,
                  height: 25,
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
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 16, left: 16),

                        child: Text(
                          'Staff Availability',
                          style: TextStyle(
                            fontFamily: 'Poppins_semi',
                            fontSize: 20,
                            color: Color(0xFF142247),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 16, left: 36, right: 36),
                        child: Text(
                          cutOffDateText,
                          style: TextStyle(
                            fontFamily: 'Poppins_normal',
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      child: Row(
                        children: [
                          Spacer(),
                          IconButton(
                            onPressed: () => _showDatePicker(context,_daysOfMonth.first),
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
                            int selectedIndex = _daysOfMonth.indexWhere((
                                date) => isSameDay(date, selectedDate));
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
                                  if (manufacturerListResponse.usersUnavailabilityFullmonth != null) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFCCCCCC),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${date.day}',
                                        style: TextStyle(
                                          color: Color(0xFF142247),
                                          fontSize: 14,
                                          fontFamily: 'Poppins_normal',
                                        ),
                                      ),
                                    );
                                  }
                                  else {
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
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Color(0xFF066E95),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: message != null &&
                                          message!.isNotEmpty,
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          message!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Poppins_normal',
                                            fontWeight: FontWeight.normal,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
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
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      height: 1,
                                      color: Colors.transparent,
                                    ),
                                    SizedBox(height: 10),
                                    Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Colors
                                            .transparent,
                                      ),
                                      child: CheckboxListTile(
                                        title: Text(
                                          daytext,
                                          style: TextStyle(
                                            fontFamily: 'Poppins_normal',
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        value: _isAvalabilityChecked,
                                        onChanged: (value) {
                                          setState(() {
                                            _isAvalabilityChecked = value!;
                                          });
                                        },
                                        controlAffinity: ListTileControlAffinity
                                            .trailing,
                                        activeColor: Colors.transparent,
                                        checkColor: Colors.transparent,
                                        secondary: _isAvalabilityChecked
                                            ? Icon(
                                          Icons.check_box,
                                          color: Colors.white,
                                        )
                                            : Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Colors
                                            .transparent,
                                      ),
                                      child: CheckboxListTile(
                                        title: Text(
                                          aftertext,
                                          style: TextStyle(
                                            fontFamily: 'Poppins_normal',
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        value: _isAfterNoonAvalabilityChecked,
                                        onChanged: (value) {
                                          setState(() {
                                            _isAfterNoonAvalabilityChecked = value!;
                                          });
                                        },
                                        controlAffinity: ListTileControlAffinity
                                            .trailing,
                                        activeColor: Colors.transparent,
                                        checkColor: Colors.transparent,
                                        secondary: _isAfterNoonAvalabilityChecked
                                            ? Icon(
                                          Icons.check_box,
                                          color: Colors.white,
                                        )
                                            : Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Colors
                                            .transparent,
                                      ),
                                      child: CheckboxListTile(
                                        title: Text(
                                          nighttext,
                                          style: TextStyle(
                                            fontFamily: 'Poppins_normal',
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        value: _isNightAvalabilityChecked,
                                        onChanged: (value) {
                                          setState(() {
                                            _isNightAvalabilityChecked = value!;
                                          });
                                        },
                                        controlAffinity: ListTileControlAffinity
                                            .trailing,
                                        activeColor: Colors.transparent,
                                        checkColor: Colors.transparent,
                                        secondary: _isNightAvalabilityChecked
                                            ? Icon(
                                          Icons.check_box,
                                          color: Colors.white,
                                        )
                                            : Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        getsave();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          save_availability,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Poppins_normal',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF73CDEF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              16),
                                        ),
                                        minimumSize: Size(double.infinity, 40),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(25),
                            child: MaterialButton(
                              onPressed: () {
                                makeentireMonthUnavailable(
                                    user_id, '$currentmonth', '$currentyear',
                                    entire_month_unavailable);
                              },
                              child: Text(
                                resetbtntext,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins_normal',
                                ),
                              ),
                              color: Color(0xFF066E95),
                              minWidth: 250,
                              height: 50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'ERP',
                                    style: TextStyle(
                                      fontFamily: 'Poppins_normal',
                                      color: Color(0xFF142247),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: _textEditingController,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                          color: Color(0xFF142247),
                                          fontFamily: 'Poppins_normal',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 1,
                                color: Color(0xFF142247),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'MAX',
                                    style: TextStyle(
                                      fontFamily: 'Poppins_normal',
                                      color: Color(0xFF142247),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      child: TextFormField(
                                        controller: _textEditingControllermx,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                          color: Color(0xFF142247),
                                          fontFamily: 'Poppins_normal',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 1,
                                color: Color(0xFF142247),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFF142247)
                                  , // Specify the desired color for the line
                                  width: 1.0, // Specify the desired width for the line
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Between FS Shift',
                                    style: TextStyle(
                                      fontFamily: 'Poppins_normal',
                                      color: Color(0xFF142247),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: double.infinity,
                                    child: DropdownButtonFormField(
                                      value: _selectedValue,
                                      items: _options.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                              fontFamily: 'Poppins_normal',
                                              color: Color(0xFF142247),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          _selectedValue = value!;
                                        });
                                      },
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 1, 20, 20),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Notes',
                                  style: TextStyle(
                                    fontFamily: 'Poppins_normal',
                                    color: Color(0xFF142247),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFF142247)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextFormField(
                                    controller: _textControllernotes,
                                    minLines: 3,
                                    maxLines: null,
                                    style: TextStyle(
                                      color: Color(0xFF142247),
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    /* if(_selectedValuess=="Select FS"){
                                      setstaffAvailabilityOtherData(
                                          user_id, '$currentmonth', '$currentyear', '$_selectedValueerp',
                                          '$_selectedValuemx',"",_textControllernotes.text);
                                    }else
                                    {*/
                                    if (_selectedValue == "No") {
                                      setstaffAvailabilityOtherData(
                                          user_id,
                                          '$currentmonth',
                                          '$currentyear',
                                          _textEditingController.text,
                                          _textEditingControllermx.text,
                                          "0",
                                          _textControllernotes.text);
                                    }
                                    else {
                                      setstaffAvailabilityOtherData(
                                          user_id,
                                          '$currentmonth',
                                          '$currentyear',
                                          _textEditingController.text,
                                          _textEditingControllermx.text,
                                          "1",
                                          _textControllernotes.text);
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      "Submit Month’s Availability",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins_normal',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF142247),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    minimumSize: Size(double.infinity, 40),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
    if (specialDateMap.containsKey(date)) {
      return specialDateMap[date] ??
          false; // Return the cached result, or false if null
    }

    for (int i = 0; i < manufacturerList.length; i++) {
      if (manufacturerList[i].year != null &&
          manufacturerList[i].month != null &&
          manufacturerList[i].date != null) {
        DateTime date22 = DateTime(
          int.parse(manufacturerList[i].year!),
          int.parse(manufacturerList[i].month!),
          manufacturerList[i].date!,
        );

        if (date.day == date22.day && manufacturerList[i].message != "") {
          specialDateMap[date] = true; // Cache the result as true
          return true;
        }
      }
    }

    specialDateMap[date] = false; // Cache the result as false
    return false;
  }

  Future<void> fetchDataanew() async {
    processedDates.clear();
    specialDateMap.clear();
    manufacturerListResponse = await fetchdata;
    _daysOfMonth.clear();
    setState(() {
      manufacturerList.clear();
      manufacturerList = manufacturerListResponse.data!;
    });
    late List<DateTime> _daysOfMonthss = [];
    for (int i = 0; i < manufacturerListResponse.data!.length; i++) {
      try {
        DateTime dd = DateTime(
            int.parse(manufacturerListResponse.data![i].year!),
            int.parse(manufacturerListResponse.data![i].month!),
            manufacturerListResponse.data![i].date!);
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
      if (manufacturerListResponse.usersUnavailabilityFullmonth == null) {
        resetbtntext = "Entirely unavailable for the month";
        save_availability = "Save Availability";
        entire_month_unavailable = "1";
      } else {
        entire_month_unavailable = "0";
        resetbtntext = "Re-set Available for the month";
        save_availability = "Save Individual Date Available";
      }

      if (!(manufacturerListResponse.calenderOtherDetail == null)) {
        if (!(manufacturerListResponse.calenderOtherDetail?.note == null)) {
          notes = manufacturerListResponse.calenderOtherDetail?.note;
          _textControllernotes.text = notes!;
        }else{
          _textControllernotes.text = "";
        }

        if (!(manufacturerListResponse.calenderOtherDetail?.erp == null)) {
          String erpString = manufacturerListResponse.calenderOtherDetail
              ?.erp ?? '0';
          _textEditingController.text = erpString;
        }else{
          _textEditingController.text = "0";
        }

        if (!(manufacturerListResponse.calenderOtherDetail?.max == null)) {
          String maxString = manufacturerListResponse.calenderOtherDetail
              ?.max ?? '0';
          _textEditingControllermx.text = maxString;
        }else{
          _textEditingControllermx.text = "0";
        }

        if (!(manufacturerListResponse.calenderOtherDetail?.samfs == null)) {
          String samfsString = manufacturerListResponse.calenderOtherDetail
              ?.samfs ?? '0';
          int samf = int.tryParse(samfsString) ?? 0;
          if (samf == 1) {
            _selectedValue = "Yes";
          } else {
            _selectedValue = "No";
            //spinner_yes.setSelection(2);
          }
        }
      }else{
      _textControllernotes.text = "";
      _textEditingController.text = "0";
      _textEditingControllermx.text = "0";
      _selectedValue = "Yes";
      }

      List<StaffData> dates = [];
      cutOffDateText = manufacturerListResponse.calendeMsg!;
      for (int i = 0; i < manufacturerList.length; i++) {
        DateTime date22 = DateTime(int.parse(manufacturerList[i].year!),
            int.parse(manufacturerList[i].month!), manufacturerList[i].date!);
        if (_selectedDate == date22) {
          _selectedDate = date22;
          if (!(manufacturerList[i].message == null)) {
            message = manufacturerList[i].message;
          }
          DateTime date2 = DateTime(int.parse(manufacturerList[i].year!),
              int.parse(manufacturerList[i].month!), manufacturerList[i].date!);
          DateFormat formatter2 = DateFormat('dd MMM yyyy');
          String newDateString2 = formatter2.format(date2);
          dateSelection = newDateString2;
          if (!(manufacturerList[i].message == null)) {
            message = manufacturerList[i].message;
          } else {
            message = '';
          }
          if (manufacturerListResponse.usersUnavailabilityFullmonth != null) {
            if (!(manufacturerList[i].datedata?.length == 0)) {
              String ? day = manufacturerList[i].datedata?[0].dayUnavailable;
              if (day == "0") {
                _isAvalabilityChecked = true;
                daytext = "Day available";
              } else {
                _isAvalabilityChecked = false;
                daytext = "Day available";
              }
              String ? after = manufacturerList[i].datedata?[0].afternoonUnavailable;
              if (after == "0") {
                _isAfterNoonAvalabilityChecked = true;
                aftertext = "Afternoon available";
              } else {
                _isAfterNoonAvalabilityChecked = false;
                aftertext = "Afternoon available";
              }

              String ? night = manufacturerList[i].datedata?[0]
                  .nightUnavailable;
              if (night == "0") {
                _isNightAvalabilityChecked = true;
                nighttext = "Night available";
              } else {
                _isNightAvalabilityChecked = false;
                nighttext = "Night available";
              }
            } else {
              daytext = "Day available";
              nighttext = "Night available";
              aftertext = "Afternoon available";
              _isAvalabilityChecked = false;
              _isAfterNoonAvalabilityChecked = false;
              _isNightAvalabilityChecked = false;
            }
          } else {
            if (!(manufacturerList[i].datedata?.length == 0)) {
              String ? day = manufacturerList[i].datedata?[0].dayUnavailable;
              if (day == "1") {
                _isAvalabilityChecked = true;
                daytext = "Day Unavailable";
              } else {
                _isAvalabilityChecked = false;
                daytext = "Day Unavailable";
              }
              String ? after = manufacturerList[i].datedata?[0].afternoonUnavailable;
              if (after == "1") {
                _isAfterNoonAvalabilityChecked = true;
                aftertext = "Afternoon Unavailable";
              } else {
                _isAfterNoonAvalabilityChecked = false;
                aftertext = "Afternoon Unavailable";
              }
              String ? night = manufacturerList[i].datedata?[0]
                  .nightUnavailable;
              if (night == "1") {
                _isNightAvalabilityChecked = true;
                nighttext = "Night Unavailable";
              } else {
                _isNightAvalabilityChecked = false;
                nighttext = "Night Unavailable";
              }
            } else {
              daytext = "Day Unavailable";
              nighttext = "Night Unavailable";
              aftertext = "Afternoon Unavailable";
              _isAvalabilityChecked = false;
              _isAfterNoonAvalabilityChecked = false;
              _isNightAvalabilityChecked = false;
            }
          }
        }
      }
    });
  }

  void getupdateddata(String month, String year) {
    fetchdata = ProcedureApiService.fetchRouteData(user_id, month, year);
    fetchDataanew();
  }

  void getsave() {
    specialDateMap.clear();
    processedDates.clear();
    if (manufacturerListResponse.usersUnavailabilityFullmonth != null) {
      if (_isAvalabilityChecked) {
        _isAvalabilityCheckedStatus = "1";
      } else {
        _isAvalabilityCheckedStatus = "0";
      }
      if (_isAfterNoonAvalabilityChecked) {
        _isAfterNoonAvalabilityCheckedStatus = "1";
      } else {
        _isAfterNoonAvalabilityCheckedStatus = "0";
      }
      if (_isNightAvalabilityChecked) {
        _isNightAvalabilityCheckedstatus = "1";
      } else {
        _isNightAvalabilityCheckedstatus = "0";
      }
      if ((_isAvalabilityCheckedStatus == "1") && (_isNightAvalabilityCheckedstatus == "1") && (_isAfterNoonAvalabilityCheckedStatus == "1")) {
        //111
        setstaffAvailability(_isAvalabilityCheckedStatus, _isNightAvalabilityCheckedstatus, _isAfterNoonAvalabilityCheckedStatus,"1");
      } else if ((_isAvalabilityCheckedStatus == "0") && (_isNightAvalabilityCheckedstatus == "0")&& (_isAfterNoonAvalabilityCheckedStatus == "0")) {
        //000
        setstaffAvailability(_isAvalabilityCheckedStatus, _isNightAvalabilityCheckedstatus, _isAfterNoonAvalabilityCheckedStatus,"0");
      } else if ((_isAvalabilityCheckedStatus == "1")  && (_isNightAvalabilityCheckedstatus == "0")&& (_isAfterNoonAvalabilityCheckedStatus =="1" )) {
        //101
        setstaffAvailability(_isAvalabilityCheckedStatus, "", _isAfterNoonAvalabilityCheckedStatus,"1");
      }  else if ((_isAvalabilityCheckedStatus == "1") && ( _isNightAvalabilityCheckedstatus =="0") && (_isAfterNoonAvalabilityCheckedStatus == "0")) {
        //100
        setstaffAvailability(_isAvalabilityCheckedStatus, "", "","1");
      }else if ((_isAvalabilityCheckedStatus == "1") && (_isNightAvalabilityCheckedstatus == "1") && (_isAfterNoonAvalabilityCheckedStatus == "0") ){
        //110
        setstaffAvailability(_isAvalabilityCheckedStatus, _isNightAvalabilityCheckedstatus, "","1");
      }else if ((_isAvalabilityCheckedStatus == "0") && (_isNightAvalabilityCheckedstatus == "1") && (_isAfterNoonAvalabilityCheckedStatus == "1") ){
        //011
        setstaffAvailability("", _isNightAvalabilityCheckedstatus, _isAfterNoonAvalabilityCheckedStatus,"1");
      }else if ((_isAvalabilityCheckedStatus == "0") && (_isNightAvalabilityCheckedstatus == "0") && (_isAfterNoonAvalabilityCheckedStatus == "1") ){
        //001
        setstaffAvailability("", "", _isAfterNoonAvalabilityCheckedStatus,"1");
      }else if ((_isAvalabilityCheckedStatus == "0") && (_isNightAvalabilityCheckedstatus == "1") && (_isAfterNoonAvalabilityCheckedStatus == "0") ){
        //010
        setstaffAvailability("", _isNightAvalabilityCheckedstatus, "","1");
      }
    } else {
      if (_isAvalabilityChecked) {
        _isAvalabilityCheckedStatus = "0";
      } else {
        _isAvalabilityCheckedStatus = "1";
      }
      if (_isNightAvalabilityChecked) {
        _isNightAvalabilityCheckedstatus = "0";
      } else {
        _isNightAvalabilityCheckedstatus = "1";
      }
      if (_isAfterNoonAvalabilityChecked) {
        _isAfterNoonAvalabilityCheckedStatus = "0";
      } else {
        _isAfterNoonAvalabilityCheckedStatus = "1";
      }
      if ((_isAvalabilityCheckedStatus == "1") && (_isNightAvalabilityCheckedstatus == "1") && (_isAfterNoonAvalabilityCheckedStatus == "1")) {
        //111
        setstaffAvailability(_isAvalabilityCheckedStatus, _isNightAvalabilityCheckedstatus, _isAfterNoonAvalabilityCheckedStatus,"1");
      } else if ((_isAvalabilityCheckedStatus == "0") && (_isNightAvalabilityCheckedstatus == "0")&& (_isAfterNoonAvalabilityCheckedStatus == "0")) {
        //000
        setstaffAvailability(_isAvalabilityCheckedStatus, _isNightAvalabilityCheckedstatus, _isAfterNoonAvalabilityCheckedStatus,"0");
      } else if ((_isAvalabilityCheckedStatus == "1")  && (_isNightAvalabilityCheckedstatus == "0")&& (_isAfterNoonAvalabilityCheckedStatus =="1" )) {
        //101
        setstaffAvailability(_isAvalabilityCheckedStatus, "", _isAfterNoonAvalabilityCheckedStatus,"1");
      }  else if ((_isAvalabilityCheckedStatus == "1") && ( _isNightAvalabilityCheckedstatus =="0") && (_isAfterNoonAvalabilityCheckedStatus == "0")) {
        //100
        setstaffAvailability(_isAvalabilityCheckedStatus, "", "","1");
      }else if ((_isAvalabilityCheckedStatus == "1") && (_isNightAvalabilityCheckedstatus == "1") && (_isAfterNoonAvalabilityCheckedStatus == "0") ){
        //110
        setstaffAvailability(_isAvalabilityCheckedStatus, _isNightAvalabilityCheckedstatus, "","1");
      }else if ((_isAvalabilityCheckedStatus == "0") && (_isNightAvalabilityCheckedstatus == "1") && (_isAfterNoonAvalabilityCheckedStatus == "1") ){
        //011
        setstaffAvailability("", _isNightAvalabilityCheckedstatus, _isAfterNoonAvalabilityCheckedStatus,"1");
      }else if ((_isAvalabilityCheckedStatus == "0") && (_isNightAvalabilityCheckedstatus == "0") && (_isAfterNoonAvalabilityCheckedStatus == "1") ){
        //001
        setstaffAvailability("", "", _isAfterNoonAvalabilityCheckedStatus,"1");
      }else if ((_isAvalabilityCheckedStatus == "0") && (_isNightAvalabilityCheckedstatus == "1") && (_isAfterNoonAvalabilityCheckedStatus == "0") ){
        setstaffAvailability("", _isNightAvalabilityCheckedstatus, "","1");
      }
    }
  }

  void setstaffAvailability(String dayUnavailable, String nightUnavailable,String afternoon_unavailable, String available) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url =
      Uri.parse(AppUrls.baseUrl + AppUrls.setstaffAvailability);
      Map body = {
        'user_id': user_id.toString(),
        'month': '$currentmonth',
        'year': '$currentyear',
        'date': '$currentday',
        'day_unavailable': dayUnavailable,
        'night_unavailable': nightUnavailable,
        'available_unavailable': available,
        'afternoon_unavailable':afternoon_unavailable
      };
      http.Response response;
      EasyLoading.show(status: 'loading...');
      response=await http.post(url, body: jsonEncode(body), headers: headers);
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['errorCode'] == "0") {
          Notify.snackbar(""," Availability successfully changed!");
            getupdateddata('$currentmonth','$currentyear');
        } else if (json['errorCode'] == "1") {
          Notify.snackbar("Failed", json['errorMsg']);
        }
      } else {
        Notify.snackbar("Failed", "Something is Worng");
      }
    } catch (e) {
      Notify.snackbar("Failed", "Something is Worng");
    }
  }

  Future<void> makeentireMonthUnavailable(user_id, month, year, entire_month_unavailable) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url =
      Uri.parse(AppUrls.baseUrl + AppUrls.entireMonthUnavailable);
      Map body = {
        'user_id': user_id.toString(),
        'month': month.toString(),
        'year': year.trim(),
        'entire_month_unavailable': entire_month_unavailable,
      };

      http.Response response;
      EasyLoading.show(status: 'loading...');
      response=await http.post(url, body: jsonEncode(body), headers: headers);
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        //Notify.snackbar("Success", " Successfully !");
        if (json['errorCode'] == "0") {
          Notify.snackbar("Success", " Successfully !");
            getupdateddata('$currentmonth','$currentyear');
        } else if (json['errorCode'] == "1") {
          Notify.snackbar("Failed", json['errorMsg']);
        }
      } else {
        Notify.snackbar("Failed", "Something is Worng");
      }
    } catch (e) {
      Notify.snackbar("Failed", "Something is Worng");
    }
  }

  void setstaffAvailabilityOtherData(String user_id,String month,String year,String erp,String max,String samfs,String notes) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url =
      Uri.parse(AppUrls.baseUrl + AppUrls.setstaffAvailabilityOtherData);
      Map body = {
        'user_id': user_id,
        'month': month,
        'year': year,
        'erp': erp,
        'max': max,
        'samfs': samfs,
        'note': notes,
      };

      http.Response response;
      EasyLoading.show(status: 'loading...');
      response=await http.post(url, body: jsonEncode(body), headers: headers);
      EasyLoading.dismiss();
      FocusManager.instance.primaryFocus?.unfocus();
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        //Notify.snackbar("Success", "Login Successfully !");
        if (json['errorCode'] == "0") {
          Notify.snackbar(""," Successfully chnaged!");
            getupdateddata('$currentmonth','$currentyear');
        } else if (json['errorCode'] == "1") {
          Notify.snackbar("Failed", json['errorMsg']);
        }
      } else {
        Notify.snackbar("Failed", "Something is Worng");
      }
    } catch (e) {
      Notify.snackbar("Failed", "Something is Worng");
    }
  }

}
