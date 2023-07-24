import 'dart:convert';

StaffshiftNotificationResponce routeModelFromJson(String str) => StaffshiftNotificationResponce.fromJson(json.decode(str));

String routeModelToJson(StaffshiftNotificationResponce data) => json.encode(data.toJson());

class StaffshiftNotificationResponce {
  String? errorCode;
  String? errorMsg;
  List<NotificationData>? data;

  StaffshiftNotificationResponce({this.errorCode, this.errorMsg, this.data});

  StaffshiftNotificationResponce.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(new NotificationData.fromJson(v));
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

class NotificationData {
  String? id;
  String? subject;
  String? mailData;
  String? userId;
  String? createdAt;
  int? offloadShiftGrab;

  NotificationData(
      {this.id,
        this.subject,
        this.mailData,
        this.userId,
        this.createdAt,
        this.offloadShiftGrab});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    mailData = json['mail_data'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    offloadShiftGrab = json['offload_shift_grab'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject'] = this.subject;
    data['mail_data'] = this.mailData;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['offload_shift_grab'] = this.offloadShiftGrab;
    return data;
  }
}