
import 'dart:convert';

StaffshiftGrablistResponce routeModelFromJsons(String str) => StaffshiftGrablistResponce.fromJson(json.decode(str));

String routeModelToJson(StaffshiftGrablistResponce data) => json.encode(data.toJson());

class StaffshiftGrablistResponce {
  String? errorCode;
  String? errorMsg;
  List<GrabListData>? data;
  List<Current>? current;
  List<Completed>? completed;

  StaffshiftGrablistResponce({this.errorCode, this.errorMsg, this.data});

  StaffshiftGrablistResponce.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
    if (json['data'] != null) {
      data = <GrabListData>[];
      json['data'].forEach((v) {
        data!.add(new GrabListData.fromJson(v));
      });
    }
    if (json['current'] != null) {
      current = <Current>[];
      json['current'].forEach((v) {
        current!.add(new Current.fromJson(v));
      });
    }
    if (json['completed'] != null) {
      completed = <Completed>[];
      json['completed'].forEach((v) {
        completed!.add(new Completed.fromJson(v));
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
    if (this.current != null) {
      data['current'] = this.current!.map((v) => v.toJson()).toList();
    }
    if (this.completed != null) {
      data['completed'] = this.completed!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GrabListData {
  String? id;
  String? subject;
  String? mailData;
  String? userId;
  String? status;
  String? createdAt;
  String? shiftDate;
  String? offloadDate;
  int? offloadShiftGrab;

  GrabListData(
      {this.id,
        this.subject,
        this.mailData,
        this.userId,
        this.status,
        this.createdAt,
        this.shiftDate,
        this.offloadDate,
        this.offloadShiftGrab});

  GrabListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    mailData = json['mail_data'];
    userId = json['user_id'];
    status=json['status'];
    createdAt = json['created_at'];
    shiftDate = json['shift_date'];
    offloadDate = json['offload_date'];
    offloadShiftGrab = json['offload_shift_grab'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['mail_data'] = this.mailData;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['shift_date'] = this.shiftDate;
    data['offload_date'] = this.offloadDate;
    data['offload_shift_grab'] = this.offloadShiftGrab;
    return data;
  }
}

class Current {
  String? id;
  String? reminderId;
  String? shiftDate;
  String? offloadDate;
  String? subject;
  int? offloadShiftGrab;
  String? msg;
  String? mailData;
  String? locationName;
  String? platformName;
  String? startTime;
  String? endTime;
  String? stateId;
  String? status;
  String? offloadReminderStatus;


  Current(
      {this.id,
        this.reminderId,
        this.shiftDate,
        this.offloadDate,
        this.subject,
        this.offloadShiftGrab,
        this.msg,
        this.mailData,
        this.locationName,
        this.platformName,
        this.startTime,
        this.endTime,
        this.stateId,
        this.status,
        this.offloadReminderStatus});

  Current.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reminderId = json['reminder_id'];
    shiftDate = json['shift_date'];
    offloadDate = json['offload_date'];
    subject = json['subject'];
    offloadShiftGrab = json['offload_shift_grab'];
    msg = json['msg'];
    mailData = json['mail_data'];
    locationName = json['location_name'];
    platformName = json['platform_name'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    stateId = json['state_id'];
    status = json['status'];
    offloadReminderStatus = json['offload_reminder_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reminder_id'] = this.reminderId;
    data['shift_date'] = this.shiftDate;
    data['offload_date'] = this.offloadDate;
    data['subject'] = this.subject;
    data['offload_shift_grab'] = this.offloadShiftGrab;
    data['msg'] = this.msg;
    data['mail_data'] = this.mailData;
    data['location_name'] = this.locationName;
    data['platform_name'] = this.platformName;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['state_id'] = this.stateId;
    data['status'] = this.status;
    data['offload_reminder_status'] = this.offloadReminderStatus;
    return data;
  }
}

class Completed {
  String? id;
  String? subject;
  String? mailData;
  String? userId;
  String? status;
  String? createdAt;
  String? shiftDate;
  String? offloadDate;
  int? offloadShiftGrab;

  Completed(
      {this.id,
        this.subject,
        this.mailData,
        this.userId,
        this.status,
        this.createdAt,
        this.shiftDate,
        this.offloadDate,
        this.offloadShiftGrab});

  Completed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    mailData = json['mail_data'];
    userId = json['user_id'];
    status=json['status'];
    createdAt = json['created_at'];
    shiftDate = json['shift_date'];
    offloadDate = json['offload_date'];
    offloadShiftGrab = json['offload_shift_grab'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['mail_data'] = this.mailData;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['shift_date'] = this.shiftDate;
    data['offload_date'] = this.offloadDate;
    data['offload_shift_grab'] = this.offloadShiftGrab;
    return data;
  }
}