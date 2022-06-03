// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:memoire/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Api.dart';

class User {
  int? id;
  String? name;
  String? image;
  String? email;
  String? token;
  var usertype;

  User({this.id, this.name, this.image, this.email, this.token, this.usertype});

  // function to convert json data to user model
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['user_id'],
        name: json['user']['name'],
        email: json['user']['email'],
        image: json['user']['image'],
        token: json['token'],
        usertype: json['user']['type']);
  }
}

Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('$url/user'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));

        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// get token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// get user id
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

postDataWithImage(filepath) async {
  var fullUrl = '$url/image';
  String token = await getToken();
  Map<String, String> headers = {
    'Content-Type': 'multipart/form-data',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var request = http.MultipartRequest('POST', Uri.parse(fullUrl))
    ..headers.addAll(headers)
    ..files.add(await http.MultipartFile.fromPath('image', filepath));
  return await request.send();
}

// Delete image
Future<ApiResponse> deleteImage() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(Uri.parse('$url/user/image/delete'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = 'Image deleted';
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

registerImage(filepath, id, location, lat, long, phone) async {
  var fullUrl = '$url/signup';
  String token = await getToken();
  Map<String, String> headers = {
    'Content-Type': 'multipart/form-data',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var request = http.MultipartRequest('POST', Uri.parse(fullUrl))
    ..headers.addAll(headers)
    ..fields['location'] = location.toString()
    ..fields['agency_id'] = id.toString()
    ..fields['latitude'] = lat.toString()
    ..fields['longitude'] = long.toString()
    ..fields['phone'] = phone.toString()
    ..files.add(await http.MultipartFile.fromPath('image', filepath));
  return await request.send();
}
