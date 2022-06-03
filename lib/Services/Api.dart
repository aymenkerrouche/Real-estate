// ignore_for_file: file_names, prefer_typing_uninitialized_variables, unused_element, avoid_print, unused_local_variable, prefer_collection_literals

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:memoire/utils/constant.dart';

import 'userController.dart';

class Api {
  postData(data, apiUrl) async {
    String token = await getToken();
    var fullUrl = url + apiUrl;
    return await http
        .post(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
  }
}

class ApiResponse {
  Object? data;
  String? error;
}

