// ignore_for_file: prefer_typing_uninitialized_variables, file_names, prefer_collection_literals

import 'dart:convert';

import 'package:memoire/screens/map_page.dart';
import 'package:memoire/utils/constant.dart';
import 'package:memoire/utils/data.dart';
import 'package:memoire/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Api.dart';




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
Future<ApiResponse> register(String name, String email, String password, String u) async {
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
  MapScreen.adrs = null;
  return await pref.clear();
}

// Update user
Future<ApiResponse> updateUser([String? name, String? email, String? password]) async {
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
