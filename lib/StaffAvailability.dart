
import 'dart:convert';

StaffAvailability routeModelFromJson(String str) => StaffAvailability.fromJson(json.decode(str));

String routeModelToJson(StaffAvailability data) => json.encode(data.toJson());


class StaffAvailability {
  String? errorCode;
  String? errorMsg;
  List<StaffData>? data;
  UsersUnavailabilityFullmonth? usersUnavailabilityFullmonth;
  String? calendeMsg;
  CalenderOtherDetail? calenderOtherDetail;

  StaffAvailability(
      {this.errorCode,
        this.errorMsg,
        this.data,
        this.usersUnavailabilityFullmonth,
        this.calendeMsg,
        this.calenderOtherDetail});

  StaffAvailability.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
    if (json['data'] != null) {
      data = <StaffData>[];
      json['data'].forEach((v) {
        data!.add(new StaffData.fromJson(v));
      });
    }
    usersUnavailabilityFullmonth =
    json['users_unavailability_fullmonth'] != null
        ? new UsersUnavailabilityFullmonth.fromJson(
        json['users_unavailability_fullmonth'])
        : null;
    calendeMsg = json['calende_msg'];
    calenderOtherDetail = json['calender_other_detail'] != null
        ? new CalenderOtherDetail.fromJson(json['calender_other_detail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.usersUnavailabilityFullmonth != null) {
      data['users_unavailability_fullmonth'] =
          this.usersUnavailabilityFullmonth!.toJson();
    }
    data['calende_msg'] = this.calendeMsg;
    if (this.calenderOtherDetail != null) {
      data['calender_other_detail'] = this.calenderOtherDetail!.toJson();
    }
    return data;
  }
}

class StaffData {
  int? date;
  String? month;
  String? year;
  String? message;
  List<Datedata>? datedata;

  StaffData({this.date, this.month, this.year, this.message, this.datedata});

  StaffData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    month = json['month'];
    year = json['year'];
    message = json['message'];
    if (json['datedata'] != null) {
      datedata = <Datedata>[];
      json['datedata'].forEach((v) {
        datedata!.add(new Datedata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['month'] = this.month;
    data['year'] = this.year;
    data['message'] = this.message;
    if (this.datedata != null) {
      data['datedata'] = this.datedata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Datedata {
  String? id;
  String? dayUnavailable;
  String? afternoonUnavailable;
  String? nightUnavailable;
  String? day;
  String? month;
  String? year;

  Datedata(
      {this.id,
        this.dayUnavailable,
        this.afternoonUnavailable,
        this.nightUnavailable,
        this.day,
        this.month,
        this.year});

  Datedata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dayUnavailable = json['day_unavailable'];
    afternoonUnavailable = json['afternoon_unavailable'];
    nightUnavailable = json['night_unavailable'];
    day = json['day'];
    month = json['month'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['day_unavailable'] = this.dayUnavailable;
    data['afternoon_unavailable'] = this.afternoonUnavailable;
    data['night_unavailable'] = this.nightUnavailable;
    data['day'] = this.day;
    data['month'] = this.month;
    data['year'] = this.year;
    return data;
  }
}

class UsersUnavailabilityFullmonth {
  String? id;
  String? reminderId;
  String? userId;
  String? locationId;
  String? locationName;
  String? platformId;
  String? platformName;
  String? day;
  String? month;
  String? year;
  String? slotDate;
  String? status;
  String? createdAt;

  UsersUnavailabilityFullmonth(
      {this.id,
        this.reminderId,
        this.userId,
        this.locationId,
        this.locationName,
        this.platformId,
        this.platformName,
        this.day,
        this.month,
        this.year,
        this.slotDate,
        this.status,
        this.createdAt});

  UsersUnavailabilityFullmonth.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reminderId = json['reminder_id'];
    userId = json['user_id'];
    locationId = json['location_id'];
    locationName = json['location_name'];
    platformId = json['platform_id'];
    platformName = json['platform_name'];
    day = json['day'];
    month = json['month'];
    year = json['year'];
    slotDate = json['slot_date'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reminder_id'] = this.reminderId;
    data['user_id'] = this.userId;
    data['location_id'] = this.locationId;
    data['location_name'] = this.locationName;
    data['platform_id'] = this.platformId;
    data['platform_name'] = this.platformName;
    data['day'] = this.day;
    data['month'] = this.month;
    data['year'] = this.year;
    data['slot_date'] = this.slotDate;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class CalenderOtherDetail {
  String? id;
  String? userId;
  String? reminderId;
  String? month;
  String? year;
  String? erp;
  String? max;
  String? samfs;
  String? note;
  String? createdAt;

  CalenderOtherDetail(
      {this.id,
        this.userId,
        this.reminderId,
        this.month,
        this.year,
        this.erp,
        this.max,
        this.samfs,
        this.note,
        this.createdAt});

  CalenderOtherDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    reminderId = json['reminder_id'];
    month = json['month'];
    year = json['year'];
    erp = json['erp'];
    max = json['max'];
    samfs = json['samfs'];
    note = json['note'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['reminder_id'] = this.reminderId;
    data['month'] = this.month;
    data['year'] = this.year;
    data['erp'] = this.erp;
    data['max'] = this.max;
    data['samfs'] = this.samfs;
    data['note'] = this.note;
    data['created_at'] = this.createdAt;
    return data;
  }
}