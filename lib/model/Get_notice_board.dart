

import 'dart:convert';

Get_notice_board_ListResponce grouteModelFromJson(String str) => Get_notice_board_ListResponce.fromJson(json.decode(str));

String grouteModelToJson(Get_notice_board_ListResponce data) => json.encode(data.toJson());
class Get_notice_board_ListResponce {

  String? errorCode;
  String? errorMsg;
  List<NoticeBoardData>? data;

  Get_notice_board_ListResponce({this.errorCode, this.errorMsg, this.data});

  Get_notice_board_ListResponce.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
    if (json['data'] != null) {
      data = <NoticeBoardData>[];
      json['data'].forEach((v) {
        data!.add(new NoticeBoardData.fromJson(v));
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

class NoticeBoardData {
  String? id;
  String? stateId;
  String? subject;
  String? message;
  String? createdAt;
  String? qualification;
  String? image;
  List<NoticeBoardReply>? noticeBoardReply;

  NoticeBoardData(
      {this.id,
        this.stateId,
        this.subject,
        this.message,
        this.createdAt,
        this.qualification,
        this.image,
        this.noticeBoardReply});

  NoticeBoardData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stateId = json['state_id'];
    subject = json['subject'];
    message = json['message'];
    createdAt = json['created_at'];
    qualification = json['qualification'];
    image = json['image'];
    if (json['notice_board_reply'] != null) {
      noticeBoardReply = <NoticeBoardReply>[];
      json['notice_board_reply'].forEach((v) {
        noticeBoardReply!.add(new NoticeBoardReply.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['state_id'] = this.stateId;
    data['subject'] = this.subject;
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    data['qualification'] = this.qualification;
    data['image'] = this.image;
    if (this.noticeBoardReply != null) {
      data['notice_board_reply'] =
          this.noticeBoardReply!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NoticeBoardReply {
  String? id;
  String? noticeBoardId;
  String? userId;
  String? reply;
  String? createdAt;

  NoticeBoardReply(
      {this.id, this.noticeBoardId, this.userId, this.reply, this.createdAt});

  NoticeBoardReply.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noticeBoardId = json['notice_board_id'];
    userId = json['user_id'];
    reply = json['reply'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['notice_board_id'] = this.noticeBoardId;
    data['user_id'] = this.userId;
    data['reply'] = this.reply;
    data['created_at'] = this.createdAt;
    return data;
  }
}