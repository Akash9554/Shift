import 'dart:convert';

TotalShiftResponce routeModelFromJson(String str) => TotalShiftResponce.fromJson(json.decode(str));

String routeModelToJson(TotalShiftResponce data) => json.encode(data.toJson());

class TotalShiftResponce {
  String? errorCode;
  String? errorMsg;
  List<Null>? data;
  int? totalShiftCount;

  TotalShiftResponce(
      {this.errorCode, this.errorMsg, this.data, this.totalShiftCount});

  TotalShiftResponce.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
    totalShiftCount = json['total_shift_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    if (this.data != null) {

    }
    data['total_shift_count'] = this.totalShiftCount;
    return data;
  }
}