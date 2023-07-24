
import 'dart:convert';

StaffshiftGrablistResponce routeModelFromJson(String str) => StaffshiftGrablistResponce.fromJson(json.decode(str));

String routeModelToJson(StaffshiftGrablistResponce data) => json.encode(data.toJson());

class StaffshiftGrablistResponce {
  String? errorCode;
  String? errorMsg;
  List<GrabListData>? data;

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

class GrabListData {
  String? id;
  String? subject;
  String? mailData;
  String? userId;
  String? createdAt;
  String? shiftDate;
  String? offloadDate;
  int? offloadShiftGrab;

  GrabListData(
      {this.id,
        this.subject,
        this.mailData,
        this.userId,
        this.createdAt,
        this.shiftDate,
        this.offloadDate,
        this.offloadShiftGrab});

  GrabListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    mailData = json['mail_data'];
    userId = json['user_id'];
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
    data['created_at'] = this.createdAt;
    data['shift_date'] = this.shiftDate;
    data['offload_date'] = this.offloadDate;
    data['offload_shift_grab'] = this.offloadShiftGrab;
    return data;
  }
}