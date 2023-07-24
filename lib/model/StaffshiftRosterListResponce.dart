import 'dart:convert';

StaffshiftRosterListResponce routeModelFromJson(String str) => StaffshiftRosterListResponce.fromJson(json.decode(str));

String routeModelToJson(StaffshiftRosterListResponce data) => json.encode(data.toJson());

class StaffshiftRosterListResponce {
  String? errorCode;
  String? errorMsg;
  List<RosterListData>? data;
  List<LocationList>? locationList;

  StaffshiftRosterListResponce(
      {this.errorCode, this.errorMsg, this.data, this.locationList});

  StaffshiftRosterListResponce.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
    if (json['data'] != null) {
      data = <RosterListData>[];
      json['data'].forEach((v) {
        data!.add(new RosterListData.fromJson(v));
      });
    }
    if (json['location_list'] != null) {
      locationList = <LocationList>[];
      json['location_list'].forEach((v) {
        locationList!.add(new LocationList.fromJson(v));
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
    if (this.locationList != null) {
      data['location_list'] =
          this.locationList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RosterListData {
  int? day;
  List<LocationData>? locationData;

  RosterListData({this.day, this.locationData});

  RosterListData.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    if (json['location_data'] != null) {
      locationData = <LocationData>[];
      json['location_data'].forEach((v) {
        locationData!.add(new LocationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    if (this.locationData != null) {
      data['location_data'] =
          this.locationData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LocationData {
  String? name;
  List<LocationTimes>? locationTimes;

  LocationData({this.name, this.locationTimes});

  LocationData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['location_times'] != null) {
      locationTimes = <LocationTimes>[];
      json['location_times'].forEach((v) {
        locationTimes!.add(new LocationTimes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.locationTimes != null) {
      data['location_times'] =
          this.locationTimes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LocationTimes {
  String? time;
  List<Data>? data;

  LocationTimes({this.time, this.data});

  LocationTimes.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? colorCode;
  String? name;

  Data({this.colorCode, this.name});

  Data.fromJson(Map<String, dynamic> json) {
    colorCode = json['color_code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color_code'] = this.colorCode;
    data['name'] = this.name;
    return data;
  }
}

class LocationList {
  String? id;
  String? stateId;
  String? name;
  Null? image;
  String? createdAt;
  String? status;

  LocationList(
      {this.id,
        this.stateId,
        this.name,
        this.image,
        this.createdAt,
        this.status});

  LocationList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stateId = json['state_id'];
    name = json['name'];
    image = json['image'];
    createdAt = json['created_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['state_id'] = this.stateId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['status'] = this.status;
    return data;
  }
}