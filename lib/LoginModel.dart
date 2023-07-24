class LoginModel {
  String? errorCode;
  String? errorMsg;
  List<Data>? data;

  LoginModel({this.errorCode, this.errorMsg, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? id;
  String? userType;
  String? firstName;
  String? image;
  String? lastName; // Change the type from String to String?
  String? email;
  String? mobileNo;
  String? stateId;
  List<Qualifications>? qualifications;

  Data({
    this.id,
    this.userType,
    this.firstName,
    this.image,
    this.lastName,
    this.email,
    this.mobileNo,
    this.stateId,
    this.qualifications,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userType = json['user_type'];
    firstName = json['first_name'];
    image = json['image'];
    lastName = json['last_name'] ?? ''; // Use the null-aware operator ?? with a default value
    email = json['email'];
    mobileNo = json['mobile_no'];
    stateId = json['state_id'];
    if (json['qualifications'] != null) {
      qualifications = <Qualifications>[];
      json['qualifications'].forEach((v) {
        qualifications!.add(Qualifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_type'] = userType;
    data['first_name'] = firstName;
    data['image'] = image;
    data['last_name'] = lastName;
    data['email'] = email;
    data['mobile_no'] = mobileNo;
    data['state_id'] = stateId;
    if (qualifications != null) {
      data['qualifications'] = qualifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Qualifications {
  String? id;
  String? name;
  Null? image;
  String? createdAt;
  String? status;

  Qualifications({this.id, this.name, this.image, this.createdAt, this.status});

  Qualifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    createdAt = json['created_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    return data;
  }
}