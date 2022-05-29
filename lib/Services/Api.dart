// ignore_for_file: file_names, prefer_typing_uninitialized_variables, unused_element, avoid_print, unused_local_variable, prefer_collection_literals

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:memoire/utils/constant.dart';
import 'package:memoire/utils/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user.dart';

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

//Login
Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse('$url/login'),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password});

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = response.statusCode.toString();
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

// Register
Future<ApiResponse> register(
    String name, String email, String password, String u) async {
  var data = Map<dynamic, dynamic>();

  data['name'] = name;
  data['email'] = email;
  data['password'] = password;
  data['type'] = u;

  ApiResponse apiResponse = ApiResponse();
  final response = await http.post(Uri.parse('$url/register'),
      headers: {
        'Accept': 'application/json',
      },
      body: data);

  switch (response.statusCode) {
    case 201:
      apiResponse.data = User.fromJson(jsonDecode(response.body));
      break;
    case 422:
      final errors = jsonDecode(response.body)['errors'];
      apiResponse.error = errors[errors.keys.elementAt(0)][0];
      break;
    case 403:
      apiResponse.error = 'The provided email already exists';
      break;
    default:
      apiResponse.error = somethingWentWrong;
      break;
  }

  return apiResponse;
}

// logout
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  user = null;
  return await pref.clear();
}

// Update user
Future<ApiResponse> updateUser(
    [String? name, String? email, String? password]) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    Object body = {
      'name': name,
      'email': email,
      'password': password,
    };

    if (name == null) {
      body = {
        'email': email,
        'password': password,
      };
    }

    if (password == null && name == null) {
      body = {
        'email': email,
      };
    }

    if (email == null && name == null) {
      body = {
        'password': password,
      };
    }

    if (email == null) {
      body = {
        'name': name,
        'password': password,
      };
    }

    if (password == null && email == null) {
      body = {
        'name': name,
      };
    }

    if (name == null && email == null) {
      body = {
        'password': password,
      };
    }

    if (password == null) {
      body = {
        'name': name,
        'email': email,
      };
    }

    if (email == null && password == null) {
      body = {
        'name': name,
      };
    }

    if (name == null && password == null) {
      body = {
        'email': email,
      };
    }

    final response = await http.patch(Uri.parse('$url/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: body);

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = response.body;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
