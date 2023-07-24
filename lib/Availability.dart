import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shift/url_constants.dart';

import 'Notify.dart';
import 'SideMenu.dart';
import 'StaffAvailability.dart';
import 'StaffVisibilityApiService.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class MonthCalendar extends StatefulWidget {

  @override
  _MonthCalendarState createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  late Future<StaffAvailability> fetchdata;

  TextEditingController _textControllernotes = TextEditingController();
  ScrollController _scrollController = ScrollController();
  final getStorge=GetStorage();
  late List<DateTime> _daysOfMonth;
  DateTime? _selectedDate;
  int _selectedValueerp = 0;
  int _selectedValuemx = 0;

  List<int> _numberList = List.generate(201, (index) => index - 100);

  List<int> _numberListsec = List.generate(201, (index) => index - 100);

  String _selectedValuess = 'Select FS';
  List<String> _options = ['Select FS', 'Yes', 'No'];

  List<StaffData> manufacturerList = [];

  String cutOffDateText = 'Cut off Date for May is Wednesday, 19 April';
  String resetbtntext='Re-set Available for the month';
  String save_availability="Save Availability";
  String entire_month_unavailable="1";
  String? notes='';
  String? message='';
  String? dateSelection='';
  bool _isAvalabilityChecked = true;
  bool _isNightAvalabilityChecked = true;
  String _isAvalabilityCheckedStatus="1";
  String _isNightAvalabilityCheckedstatus="1";
  bool loopFinished = false;

  String user_id=GetStorage().read("id");


  late final DateTime firstDayOfMonth;
  late final DateTime lastDayOfMonth;
  late final DateTime? selectedDate;
  int currentday=0;
  int currentmonth=0;
  int currentyear=0;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    firstDayOfMonth = DateTime(now.year, now.month, 1);
    lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    selectedDate=firstDayOfMonth;
    currentyear = firstDayOfMonth.year;
    currentmonth = firstDayOfMonth.month;
    currentday = firstDayOfMonth.day;
    _daysOfMonth = [];
    _daysOfMonth.clear();
    getupdateddatafirst('$currentmonth','$currentyear');
  }

  void getupdateddatafirst(String month,String year){
    fetchdata = ProcedureApiService.fetchRouteData(user_id,month,year);
    fetchDataa();
  }

  Future<void> fetchDataa() async {
    StaffAvailability manufacturerListResponse = await fetchdata;
    late List<DateTime> _daysOfMonthss = [];
    for (int i = 0; i < manufacturerListResponse.data!.length; i++) {
      try {
        DateTime dd = DateTime(int.parse(manufacturerListResponse.data![i].year!), int.parse(manufacturerListResponse.data![i].month!), manufacturerListResponse.data![i].date!);
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
        resetbtntext="Entirely unavailable for the month";
        save_availability="Save Availability";
        entire_month_unavailable="1";
      }
      else{
        entire_month_unavailable="0";
        resetbtntext="Re-set Available for the month";
        save_availability="Save Individual Date Available";

      }

      if (!(manufacturerListResponse.calenderOtherDetail==null)){
        if (!(manufacturerListResponse.calenderOtherDetail?.note==null)){
          notes=manufacturerListResponse.calenderOtherDetail?.note;
          _textControllernotes.text=notes!;
        }

        if (!(manufacturerListResponse.calenderOtherDetail?.erp==null)){
          String erpString = manufacturerListResponse.calenderOtherDetail?.erp ?? '0';
          int erp = int.tryParse(erpString) ?? 0;
          for (int i = 0; i < _numberList.length; i++) {
            if (erp == _numberList[i]) {
              _selectedValueerp = erp;
              break;
            }
          }
        }

        if (!(manufacturerListResponse.calenderOtherDetail?.max==null)){
          // int max= Integer.parseInt(response.body().getCalenderOtherDetail().getMax());
          //spinner_max.setSelection(valuesErp.indexOf(max));

          String maxString = manufacturerListResponse.calenderOtherDetail?.max ?? '0';
          int mx = int.tryParse(maxString) ?? 0;
          for (int i = 0; i < _numberListsec.length; i++) {
            if (mx == _numberListsec[i]) {
              _selectedValuemx = mx;
              break;
            }
          }

        }

        if (!(manufacturerListResponse.calenderOtherDetail?.samfs==null)){
          String samfsString = manufacturerListResponse.calenderOtherDetail?.samfs ?? '0';
          int samf = int.tryParse(samfsString) ?? 0;

          if (samf==1){
            _selectedValuess="Yes";
          }else{
            _selectedValuess="No";
          }
        }

      }
      manufacturerList.clear();
      manufacturerList = manufacturerListResponse.data!;
      List<StaffData> dates = [];
      cutOffDateText=manufacturerListResponse.calendeMsg!;
      for (int i = 0; i < manufacturerList.length; i++) {
        if(i==0){
          DateTime date22=DateTime(int.parse(manufacturerList[i].year!), int.parse(manufacturerList[i].month!), manufacturerList[i].date!);
          _selectedDate=date22;
          DateFormat formatter2 = DateFormat('dd MMM yyyy');
          String newDateString2 = formatter2.format(_selectedDate!);
          dateSelection=newDateString2;
          if (!(manufacturerList[i].message==null)){
            message=manufacturerList[i].message;
          }else{
            message='';
          }
          if (!(manufacturerList[i].datedata?.length == 0)) {
            String ? day = manufacturerList[i].datedata?[0].dayUnavailable;
            if(day=="1"){
              _isAvalabilityChecked=false;
            }else {
              _isAvalabilityChecked=true;
            }
            String ? night = manufacturerList[i].datedata?[0].nightUnavailable;
            if(night=="1"){
              _isNightAvalabilityChecked=false;
            }else {
              _isNightAvalabilityChecked=true;
            }
          }else{
            _isAvalabilityChecked=false;
            _isNightAvalabilityChecked=false;
          }
        }
      }
    });
  }

  void updateManufacturerList(int indexno) {
    DateTime dd = DateTime(int.parse(manufacturerList![indexno].year!), int.parse(manufacturerList![indexno].month!), manufacturerList![indexno].date!);
    setState(() {
      _selectedDate=dd;
      _scrollController.animateTo(
        indexno * 60, // replace `itemWidth` with your item's width
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      currentyear=dd.year;
      currentmonth=dd.month;
      currentday=dd.day;
      DateFormat formatter2 = DateFormat('dd MMM yyyy');
      String newDateString2 = formatter2.format(dd);
      dateSelection=newDateString2;


      if (!(manufacturerList[indexno].message==null)){
        message=manufacturerList[indexno].message;
      }else{
        message='';
      }
      if (!(manufacturerList[indexno].datedata?.length == 0)) {
        String ? day = manufacturerList[indexno].datedata?[0].dayUnavailable;
        if(day=="1"){
          _isAvalabilityChecked=false;
        }else {
          _isAvalabilityChecked=true;
        }
        String ? night = manufacturerList[indexno].datedata?[0].nightUnavailable;
        if(night=="1"){
          _isNightAvalabilityChecked=false;
        }else {
          _isNightAvalabilityChecked=true;
        }
      }else{
        _isAvalabilityChecked=false;
        _isNightAvalabilityChecked=false;
      }
    });
  }

  void _generateDaysOfMonth(DateTime start,DateTime end) {
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
        currentday=firstDayOfMonths.day;
        currentmonth=firstDayOfMonths.month;
        currentyear=firstDayOfMonths.year;
        _selectedDate = picked;
        _generateDaysOfMonth(firstDayOfMonths,lastDayOfMonths);
        getupdateddatafirst('$currentmonth','$currentyear');
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
                      alignment: Alignment.centerLeft,
                      child:Padding(
                        padding: EdgeInsets.only(top: 16, left: 16),

                        child: Text(
                          'Staff Availability',
                          style: TextStyle(
                            fontFamily: 'Poppins_normal',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xFF142247),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                       child: Padding(
                               padding: EdgeInsets.only(top: 16, left: 16),
                        child: Text(
                          cutOffDateText,
                          style: TextStyle(
                            fontFamily: 'Poppins_normal',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xFF142247),
                          ),
                          textAlign: TextAlign.start,
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
                Expanded(

                  child: SingleChildScrollView(
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
                              children: _daysOfMonth.asMap().entries.map((entry){
                                int index = entry.key;
                                DateTime date = entry.value;
                                bool isSelected = _selectedDate != null ? date == _selectedDate : false;
                                return GestureDetector(
                                  onTap: () {

                                    updateManufacturerList(index);
                                  },
                                  child:Container(
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: isSelected ? Color(0xFF142247) : Colors.transparent,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: isSelected ? Color(0xFF142247) : Colors.transparent,
                                        width: 4,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            DateFormat.MMM().format(date),
                                            style: TextStyle(
                                              fontFamily: 'Poppins_normal',
                                              fontWeight: FontWeight.normal,
                                              fontSize: 14,
                                              color: isSelected ? Colors.white : Color(0xFF142247),
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
                                              color: isSelected ? Colors.white : Color(0xFF142247),
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
                                              color: isSelected ? Colors.white : Color(0xFF142247),
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
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(25),
                            child: MaterialButton(
                              onPressed: () {
                                makeentireMonthUnavailable(user_id,'$currentmonth','$currentyear',entire_month_unavailable);
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
                          padding: EdgeInsets.all(20),
                          child:
                          SingleChildScrollView(
                            child: Center(
                              child:
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Color(0xFF066E95),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
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
                                    SizedBox(height: 8),
                                    Container(
                                      height: 1,
                                      color: Colors.white,

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
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),

                                    Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Colors.transparent,
                                      ),
                                      child:
                                      CheckboxListTile(
                                        title: Text(
                                          'Day unavailable',
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
                                        controlAffinity: ListTileControlAffinity.trailing,
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
                                        unselectedWidgetColor: Colors.transparent,
                                      ),
                                      child:
                                      CheckboxListTile(
                                        title: Text(
                                          'Night unavailable',
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
                                        controlAffinity: ListTileControlAffinity.trailing,
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
                                        primary: Color(0xFF73CDEF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        minimumSize: Size(double.infinity, 40),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),),
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
                                      child: DropdownButtonFormField(
                                        value: _selectedValueerp,
                                        items: _numberList.map((int value) {
                                          return DropdownMenuItem<int>(
                                            value: value,
                                            child: Text(
                                              value.toString(),
                                              style: TextStyle(
                                                fontFamily: 'Poppins_normal',
                                                color: Color(0xFF142247),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (int? value) {
                                          setState(() {
                                            _selectedValueerp = value ?? 0;
                                          });
                                        },
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
                                      child: DropdownButtonFormField(
                                        value: _selectedValuemx,
                                        items: _numberListsec.map((int value) {
                                          return DropdownMenuItem<int>(
                                            value: value,
                                            child:Text(
                                              value.toString(),
                                              style: TextStyle(
                                                fontFamily: 'Poppins_normal',
                                                color: Color(0xFF142247),
                                              ),
                                            ),);
                                        }).toList(),
                                        onChanged: (int? value) {
                                          setState(() {
                                            _selectedValuemx = value ?? 0;
                                          });
                                        },
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
                          child:  Container(
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
                                    child: Expanded(
                                      child: DropdownButtonFormField(
                                        value: _selectedValuess,
                                        items: _options.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value.toString(),
                                              style: TextStyle(
                                                fontFamily: 'Poppins_normal',
                                                color: Color(0xFF142247),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            _selectedValuess = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20,1,20,20),
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
                                    border: Border.all(color: Color(0xFF142247)),
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
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    if(_selectedValuess=="Select FS"){
                                      setstaffAvailabilityOtherData(
                                          user_id, '$currentmonth', '$currentyear', '$_selectedValueerp',
                                          '$_selectedValuemx',"",_textControllernotes.text);
                                    }else {
                                      if(_selectedValuess=="No"){
                                        setstaffAvailabilityOtherData(
                                            user_id, '$currentmonth', '$currentyear', '$_selectedValueerp',
                                            '$_selectedValuemx',"0",_textControllernotes.text);
                                      }else{
                                        setstaffAvailabilityOtherData(
                                            user_id, '$currentmonth', '$currentyear', '$_selectedValueerp',
                                            '$_selectedValuemx',"1",_textControllernotes.text);
                                      }

                                    }},
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      "Save",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins_normal',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF142247),
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

  Future<void> fetchDataanew() async {
    StaffAvailability manufacturerListResponse = await fetchdata;
    late List<DateTime> _daysOfMonthss = [];
    for (int i = 0; i < manufacturerListResponse.data!.length; i++) {
      try {
        DateTime dd = DateTime(int.parse(manufacturerListResponse.data![i].year!), int.parse(manufacturerListResponse.data![i].month!), manufacturerListResponse.data![i].date!);
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
        resetbtntext="Entirely unavailable for the month";
        save_availability="Save Availability";
        entire_month_unavailable="1";
      }
      else{
        entire_month_unavailable="0";
        resetbtntext="Re-set Available for the month";
        save_availability="Save Individual Date Available";

      }

      if (!(manufacturerListResponse.calenderOtherDetail==null)){
        if (!(manufacturerListResponse.calenderOtherDetail?.note==null)){
          notes=manufacturerListResponse.calenderOtherDetail?.note;
          _textControllernotes.text=notes!;
        }

        if (!(manufacturerListResponse.calenderOtherDetail?.erp==null)){
          String erpString = manufacturerListResponse.calenderOtherDetail?.erp ?? '0';
          int erp = int.tryParse(erpString) ?? 0;
          for (int i = 0; i < _numberList.length; i++) {
            if (erp == _numberList[i]) {
              _selectedValueerp = erp;
              break;
            }
          }
        }

        if (!(manufacturerListResponse.calenderOtherDetail?.max==null)){
          String maxString = manufacturerListResponse.calenderOtherDetail?.max ?? '0';
          int mx = int.tryParse(maxString) ?? 0;
          for (int i = 0; i < _numberListsec.length; i++) {
            if (mx == _numberListsec[i]) {
              _selectedValuemx = mx;
              break;
            }
          }
        }

        if (!(manufacturerListResponse.calenderOtherDetail?.samfs==null)){
          String samfsString = manufacturerListResponse.calenderOtherDetail?.samfs ?? '0';
          int samf = int.tryParse(samfsString) ?? 0;

          if (samf==1){
            _selectedValuess="Yes";
          }else{
            _selectedValuess="No";
            //spinner_yes.setSelection(2);
          }
        }
      }
      manufacturerList.clear();
      manufacturerList = manufacturerListResponse.data!;
      List<StaffData> dates = [];
      cutOffDateText=manufacturerListResponse.calendeMsg!;
      for (int i = 0; i < manufacturerList.length; i++) {
        DateTime date22=DateTime(int.parse(manufacturerList[i].year!), int.parse(manufacturerList[i].month!), manufacturerList[i].date!);
        if(_selectedDate==date22){
          _selectedDate=date22;
          _scrollController.animateTo(
            i * 60, // replace `itemWidth` with your item's width
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          if (!(manufacturerList[i].message==null)){
            message=manufacturerList[i].message;
          }
          DateTime date2=DateTime(int.parse(manufacturerList[i].year!), int.parse(manufacturerList[i].month!), manufacturerList[i].date!);
          DateFormat formatter2 = DateFormat('dd MMM yyyy');
          String newDateString2 = formatter2.format(date2);
          dateSelection=newDateString2;
          if (!(manufacturerList[i].message==null)){
            message=manufacturerList[i].message;
          }else{
            message='';
          }
          if (!(manufacturerList[i].datedata?.length == 0)) {
            String ? day = manufacturerList[i].datedata?[0].dayUnavailable;
            if(day=="0"){
              _isAvalabilityChecked=false;
            }else {
              _isAvalabilityChecked=true;
            }
            String ? night = manufacturerList[i].datedata?[0].nightUnavailable;
            if(night=="0"){
              _isNightAvalabilityChecked=false;
            }else {
              _isNightAvalabilityChecked=true;
            }
          }else{
            _isAvalabilityChecked=false;
            _isNightAvalabilityChecked=false;
          }

        }
      }
    });
  }

  void getupdateddata(String month,String year){
    fetchdata = ProcedureApiService.fetchRouteData(user_id,month,year);
    fetchDataanew();
  }

  void getsave() {
    if (_isAvalabilityChecked) {
      _isAvalabilityCheckedStatus = "1";
    } else {
      _isAvalabilityCheckedStatus = "0";
    }
    if (_isNightAvalabilityChecked) {
      _isNightAvalabilityCheckedstatus = "1";
    } else {
      _isNightAvalabilityCheckedstatus = "0";
    }
    if ((_isAvalabilityCheckedStatus == "1") && (_isNightAvalabilityCheckedstatus == "1")) {
      setstaffAvailability(_isAvalabilityCheckedStatus, _isNightAvalabilityCheckedstatus, "1");
    } else if ((_isAvalabilityCheckedStatus == "0") && (_isNightAvalabilityCheckedstatus == "0")) {
      setstaffAvailability(_isAvalabilityCheckedStatus, _isNightAvalabilityCheckedstatus, "0");
    } else if (_isAvalabilityCheckedStatus == "1") {
      setstaffAvailability(_isAvalabilityCheckedStatus, "", "1");
    } else if (_isNightAvalabilityCheckedstatus == "1") {
      setstaffAvailability("", _isNightAvalabilityCheckedstatus, "1");
    }

  }

  void setstaffAvailability(String dayUnavailable, String nightUnavailable, String available) async {
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
      };

      http.Response response =
      await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['errorCode'] == "0") {
          Notify.snackbar(""," Successfully chnaged!");
          setState(() {
            getupdateddata('$currentmonth','$currentyear');
          });
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

      http.Response response =
      await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        //Notify.snackbar("Success", " Successfully !");
        if (json['errorCode'] == "0") {
          Notify.snackbar("Success", " Successfully !");
          setState(() {
            getupdateddata('$currentmonth','$currentyear');
          });
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

      http.Response response =
      await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        //Notify.snackbar("Success", "Login Successfully !");
        if (json['errorCode'] == "0") {
          Notify.snackbar(""," Successfully chnaged!");
          setState(() {
            getupdateddata('$currentmonth','$currentyear');
          });
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