class StaffshiftcountResponce {
  String? errorCode;
  String? errorMsg;
  int? totalShiftCount;

  StaffshiftcountResponce(
      {this.errorCode, this.errorMsg, this.totalShiftCount});

  StaffshiftcountResponce.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
    totalShiftCount = json['total_shift_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['errorMsg'] = this.errorMsg;
    data['total_shift_count'] = this.totalShiftCount;
    return data;
  }
}