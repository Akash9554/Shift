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
import 'login.dart';


class LoginController extends GetxController {
   
  String email = "";
  String password = "";


 static login(BuildContext context,String email, String password) {
     if (password.isEmpty) {
      Notify.snackbar("Password not empty ", "Please Input Password");
    } else {
      email = email;
      password = password;
      loginWithEmail(email, password,context);
    }
  }

  static bool isEmailValid(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  static bool isPassWord(String password) {
    bool passwordValid =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-8])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(password);
    return passwordValid;
  }

  static Future<void> loginWithEmail(email, password ,context) async {

    var headers = {'Content-Type': 'application/json'};
    try {
      var url =
          Uri.parse(AppUrls.baseUrl + AppUrls.login);
      Map body = {
        'email': email.trim(),
        'password': password,
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

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

            Notify.snackbar("Success", "Login Successfully !");

            getStorge.write("id",id);
          getStorge.write("name",first_name!+" "+last_name!);
          getStorge.write("email",email);

            Get.to(MySideMenu());

        } else if (json['errorCode'] == "1") {
          Notify.snackbar("Failed", ""+json['errorMsg']);
        }
      } else {
        Notify.snackbar("Failed", "Something is wrongss ");
      }
    } catch (error) {
      Notify.snackbar("Failed", "Something is wrongs ");
    }
  }

  static forget(BuildContext context,String email) {
    if (email.isEmpty) {
      Notify.snackbar("Email not empty ", "Please Input Email");
    } else {
      email = email;
      forgetwitheamil(email,context);
    }
  }

  static Future<void> forgetwitheamil(email ,context) async {

    var headers = {'Content-Type': 'application/json'};
    try {
      var url =
      Uri.parse(AppUrls.baseUrl + AppUrls.forgetPass);
      Map body = {
        'email': email.trim(),
      };
      http.Response response =
      await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['errorCode'] == "0") {

          Notify.snackbar("Success", ""+json['errorMsg']);

          Get.to(LoginScreen());

        } else if (json['errorCode'] == "1") {
          Notify.snackbar("Failed", ""+json['errorMsg']);
        }
      } else {
        Notify.snackbar("Failed", "Something is wrongss ");
      }
    } catch (error) {
      Notify.snackbar("Failed", "Something is wrongs ");
    }
  }





}



