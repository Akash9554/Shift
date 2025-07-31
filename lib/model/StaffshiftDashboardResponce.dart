


import 'dart:convert';

StaffshiftDashboardResponce routeModelFromJson(String str) => StaffshiftDashboardResponce.fromJson(json.decode(str));

String routeModelToJson(StaffshiftDashboardResponce data) => json.encode(data.toJson());


class StaffshiftDashboardResponce {
  String? errorCode;
  String? errorMsg;
  int? totalShift;
  List<UpcommingShift>? upcommingShift;
  List<ShiftOffload>? shiftOffload;
  List<RecentCommunications>? recentCommunications;

  StaffshiftDashboardResponce(
      {this.errorCode,
        this.errorMsg,
        this.totalShift,
        this.upcommingShift,
        this.shiftOffload,
        this.recentCommunications});

  StaffshiftDashboardResponce.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
    totalShift = json['total_shift'];
    if (json['upcomming_shift'] != null) {
      upcommingShift = <UpcommingShift>[];
      json['upcomming_shift'].forEach((v) {
        upcommingShift!.add(new UpcommingShift.fromJson(v));
      });
    }
    if (json['shift_offload'] != null) {
      shiftOffload = <ShiftOffload>[];
      json['shift_offload'].forEach((v) {
        shiftOffload!.add(new ShiftOffload.fromJson(v));
      });
    }
    if (json['recent_communications'] != null) {
      recentCommunications = <RecentCommunications>[];
      json['recent_communications'].forEach((v) {
        recentCommunications!.add(new RecentCommunications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    data['total_shift'] = this.totalShift;
    if (this.upcommingShift != null) {
      data['upcomming_shift'] =
          this.upcommingShift!.map((v) => v.toJson()).toList();
    }
    if (this.shiftOffload != null) {
      data['shift_offload'] =
          this.shiftOffload!.map((v) => v.toJson()).toList();
    }
    if (this.recentCommunications != null) {
      data['recent_communications'] =
          this.recentCommunications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpcommingShift {
  String? id;
  String? reminderId;
  String? userId;
  String? locationId;
  String? locationName;
  String? platformId;
  String? platformName;
  String? qualificationId;
  String? qualificationName;
  String? fsShift;
  String? stateId;
  String? available;
  String? day;
  String? month;
  String? year;
  String? slotDate;
  String? status;
  String? createdAt;
  String? startTime;
  String? endTime;
  String? staffAll;
  String? offloadShift;
  String? offloadCreatedDate;
  String? offloadShiftUserId;
  String? availableMsg;
  int? offloadShiftCheck;
  int? recallOffloadedShift;
  int? cancelOffloadedShift;
  UserDetail? userDetail;

  UpcommingShift(
      {this.id,
        this.reminderId,
        this.userId,
        this.locationId,
        this.locationName,
        this.platformId,
        this.platformName,
        this.qualificationId,
        this.qualificationName,
        this.fsShift,
        this.stateId,
        this.available,
        this.day,
        this.month,
        this.year,
        this.slotDate,
        this.status,
        this.createdAt,
        this.startTime,
        this.endTime,
        this.staffAll,
        this.offloadShift,
        this.offloadCreatedDate,
        this.offloadShiftUserId,
        this.availableMsg,
        this.offloadShiftCheck,
        this.recallOffloadedShift,
        this.cancelOffloadedShift,
        this.userDetail});

  UpcommingShift.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reminderId = json['reminder_id'];
    userId = json['user_id'];
    locationId = json['location_id'];
    locationName = json['location_name'];
    platformId = json['platform_id'];
    platformName = json['platform_name'];
    qualificationId = json['qualification_id'];
    qualificationName = json['qualification_name'];
    fsShift = json['fs_shift'];
    stateId = json['state_id'];
    available = json['available'];
    day = json['day'];
    month = json['month'];
    year = json['year'];
    slotDate = json['slot_date'];
    status = json['status'];
    createdAt = json['created_at'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    staffAll = json['staff_all'];
    offloadShift = json['offload_shift'] ?? '';
    offloadCreatedDate = json['offload_created_date'] ?? '';
    offloadShiftUserId = json['offload_shift_user_id'] ?? '';
    availableMsg = json['available_msg'] ?? '';
    offloadShiftCheck = json['offload_shift_check'];
    recallOffloadedShift = json['recall_offloaded_shift'];
    cancelOffloadedShift = json['cancel_offloaded_shift'];
    userDetail = json['user_detail'] != null
        ? new UserDetail.fromJson(json['user_detail'])
        : null;
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
    data['qualification_id'] = this.qualificationId;
    data['qualification_name'] = this.qualificationName;
    data['fs_shift'] = this.fsShift;
    data['state_id'] = this.stateId;
    data['available'] = this.available;
    data['day'] = this.day;
    data['month'] = this.month;
    data['year'] = this.year;
    data['slot_date'] = this.slotDate;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['staff_all'] = this.staffAll;
    data['offload_shift'] = this.offloadShift;
    data['offload_created_date'] = this.offloadCreatedDate;
    data['offload_shift_user_id'] = this.offloadShiftUserId;
    data['available_msg'] = this.availableMsg;
    data['offload_shift_check'] = this.offloadShiftCheck;
    data['recall_offloaded_shift'] = this.recallOffloadedShift;
    data['cancel_offloaded_shift'] = this.cancelOffloadedShift;
    if (this.userDetail != null) {
      data['user_detail'] = this.userDetail!.toJson();
    }
    return data;
  }
}

class ShiftOffload {
  String? id;
  String? reminderId;
  List<UserDetail>? userDetail;
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

  ShiftOffload(
      {this.id,
        this.reminderId,
        this.userDetail,
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

  ShiftOffload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reminderId = json['reminder_id'];
    if (json['user_detail'] != null) {
      userDetail = <UserDetail>[];
      json['user_detail'].forEach((v) {
        userDetail!.add(new UserDetail.fromJson(v));
      });
    }
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
    if (this.userDetail != null) {
      data['user_detail'] = this.userDetail!.map((v) => v.toJson()).toList();
    }
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


class RecentCommunications {
  String? id;
  String? reminderId;
  String? subject;
  String? message;
  String? createdAt;

  RecentCommunications(
      {this.id, this.reminderId, this.subject, this.message, this.createdAt});

  RecentCommunications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reminderId = json['reminder_id'];
    subject = json['subject'];
    message = json['message'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reminder_id'] = this.reminderId;
    data['subject'] = this.subject;
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    return data;
  }
}
class UserDetail {
  String? name;
  String? surname;
  String? email;

  UserDetail({this.name, this.surname, this.email});

  UserDetail.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    surname = json['surname'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['email'] = this.email;
    return data;
  }
}