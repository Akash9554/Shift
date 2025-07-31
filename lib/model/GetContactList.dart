import 'dart:convert';

GetContactList routeModelFromJson(String str) => GetContactList.fromJson(json.decode(str));

String routeModelToJson(GetContactList data) => json.encode(data.toJson());

class GetContactList {
  String? errorCode;
  String? errorMsg;
  List<ContactData>? data;

  GetContactList({this.errorCode, this.errorMsg, this.data});

  GetContactList.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
    if (json['data'] != null) {
      data = <ContactData>[];
      json['data'].forEach((v) {
        data!.add(new ContactData.fromJson(v));
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

class ContactData {
  String? id;
  String? userType;
  String? firstName;
  String? image;
  String? lastName;
  String? email;
  Null? address;
  String? mobileNo;
  String? stateId;
  String? locationId;
  String? platformId;
  String? platformName;
  String? fsShift;
  String? bio;
  String? erp;
  String? max;
  String? samfs;
  String? deviceType;
  String? deviceToken;
  Null? latitude;
  Null? longitude;
  Null? zipcode;
  String? createdAt;
  List<Qualifications>? qualifications;
  String? noticeBoardReminder;

  ContactData(
      {this.id,
        this.userType,
        this.firstName,
        this.image,
        this.lastName,
        this.email,
        this.address,
        this.mobileNo,
        this.stateId,
        this.locationId,
        this.platformId,
        this.platformName,
        this.fsShift,
        this.bio,
        this.erp,
        this.max,
        this.samfs,
        this.deviceType,
        this.deviceToken,
        this.latitude,
        this.longitude,
        this.zipcode,
        this.createdAt,
        this.qualifications,
        this.noticeBoardReminder});

  ContactData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userType = json['user_type'];
    firstName = json['first_name'];
    image = json['image'];
    lastName = json['last_name'];
    email = json['email'];
    address = json['address'];
    mobileNo = json['mobile_no'];
    stateId = json['state_id'];
    locationId = json['location_id'];
    platformId = json['platform_id'];
    platformName = json['platform_name'];
    fsShift = json['fs_shift'];
    bio = json['bio'];
    erp = json['erp'];
    max = json['max'];
    samfs = json['samfs'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    zipcode = json['zipcode'];
    createdAt = json['created_at'];
    if (json['qualifications'] != null) {
      qualifications = <Qualifications>[];
      json['qualifications'].forEach((v) {
        qualifications!.add(new Qualifications.fromJson(v));
      });
    }
    noticeBoardReminder = json['notice_board_reminder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_type'] = this.userType;
    data['first_name'] = this.firstName;
    data['image'] = this.image;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['address'] = this.address;
    data['mobile_no'] = this.mobileNo;
    data['state_id'] = this.stateId;
    data['location_id'] = this.locationId;
    data['platform_id'] = this.platformId;
    data['platform_name'] = this.platformName;
    data['fs_shift'] = this.fsShift;
    data['bio'] = this.bio;
    data['erp'] = this.erp;
    data['max'] = this.max;
    data['samfs'] = this.samfs;
    data['device_type'] = this.deviceType;
    data['device_token'] = this.deviceToken;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['zipcode'] = this.zipcode;
    data['created_at'] = this.createdAt;
    if (this.qualifications != null) {
      data['qualifications'] =
          this.qualifications!.map((v) => v.toJson()).toList();
    }
    data['notice_board_reminder'] = this.noticeBoardReminder;
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