import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shift/url_constants.dart';

import 'StaffAvailability.dart';



class ProcedureApiService {
  static var client = http.Client();

  static Future<StaffAvailability> fetchRouteData(String userid,String month,String year) async {
    var headers = {'Content-Type': 'application/json'};
    var url =
        Uri.parse(AppUrls.baseUrl + AppUrls.staffAvailability);
    Map body = {
      'user_id': userid,
      'month':month,
      'year':year,
    };
    http.Response response =
        await http.post(url, body: jsonEncode(body), headers: headers);
    // print("Route Model Data is :........");
    // print(response.body);
    if (response.statusCode == 200) {
      return routeModelFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }




}
