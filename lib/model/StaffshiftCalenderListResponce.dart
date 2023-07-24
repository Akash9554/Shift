import 'dart:convert';

StaffshiftCalenderListResponce routeModelFromJson(String str) => StaffshiftCalenderListResponce.fromJson(json.decode(str));

String routeModelToJson(StaffshiftCalenderListResponce data) => json.encode(data.toJson());



class StaffshiftCalenderListResponce {
  String? errorCode;
  String? errorMsg;
  List<MyCalender>? data;

  StaffshiftCalenderListResponce({this.errorCode, this.errorMsg, this.data});

  StaffshiftCalenderListResponce.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
    if (json['data'] != null) {
      data = <MyCalender>[];
      json['data'].forEach((v) {
        data!.add(new MyCalender.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyCalender {
  String? date;
  String? dateBackgroundColor;
  String? day;
  String? month;
  String? year;
  String? checkBlock;
  List<String>? reminderAvailabilityData;

  MyCalender(
      {this.date,
        this.dateBackgroundColor,
        this.day,
        this.month,
        this.year,
        this.checkBlock,
        this.reminderAvailabilityData});

  MyCalender.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    dateBackgroundColor = json['date_background_color'];
    day = json['day'];
    month = json['month'];
    year = json['year'];
    checkBlock = json['check_block'];
    reminderAvailabilityData =
        json['reminder_availability_data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['date_background_color'] = this.dateBackgroundColor;
    data['day'] = this.day;
    data['month'] = this.month;
    data['year'] = this.year;
    data['check_block'] = this.checkBlock;
    data['reminder_availability_data'] = this.reminderAvailabilityData;
    return data;
  }
}