import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shift/url_constants.dart';

import 'Availability.dart';
import 'LoginModel.dart';
import 'Notify.dart';
import 'SideBar.dart';

class SignUpController extends GetxController {
  static login(BuildContext context, String first_name, String last_name, String mobile_no, String email, String password,
      String state_id, String fs_shift, String qualification_id) {
    if (password.isEmpty) {
      Notify.snackbar("Password not empty ", "Please Input Password");
    } else {
      first_name = first_name;
      last_name = last_name;
      mobile_no = mobile_no;
      email = email;
      password = password;
      state_id = state_id;
      fs_shift = fs_shift;
      qualification_id = qualification_id;
      loginWithEmail(first_name, last_name, mobile_no, email, password, state_id, fs_shift, qualification_id, context);
    }
  }

  static Future<void> loginWithEmail(
      String first_name,
      String last_name,
      String mobile_no,
      String email,
      String password,
      String state_id,
      String fs_shift,
      String qualification_id,

      BuildContext context) async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(AppUrls.baseUrl + AppUrls.signup);
      Map<String, dynamic> body = {
        'first_name': first_name,
        'last_name': last_name,
        'mobile_no': mobile_no,
        'email': email,
        'password': password,
        'state_id': state_id,
        'fs_shift': fs_shift,
        'qualification_id': qualification_id,
      };

      http.Response response = await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['errorCode'] == "0") {
          final getStorge = GetStorage();
          LoginModel loginModel = LoginModel.fromJson(json);
          String? id = loginModel.data![0].id;
          String? first_name = loginModel.data![0].firstName;
          String? last_name = loginModel.data![0].lastName;
          String? mobile_no = loginModel.data![0].mobileNo;
          String? email = loginModel.data![0].email;
          Notify.snackbar("Success", json['errorMsg']);
          getStorge.write("id", id);
          getStorge.write("name", first_name! + " " + last_name!);
          getStorge.write("email", email);
          Get.to(MySideMenu());
        } else if (json['errorCode'] == "1") {
          Notify.snackbar("Failed", "" + json['errorMsg']);
        }
      } else {
        Notify.snackbar("Failed", "Something went wrong. Please try again later.");
      }
    } catch (error) {
      // Handle API call errors
      print('API Error: $error');
      Notify.snackbar("Failed", "Something went wrong. Please try again later.");
    }
  }
}
