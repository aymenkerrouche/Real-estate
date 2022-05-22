// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:memoire/utils/constant.dart';
import 'package:memoire/widgets/input.dart';

import 'Api.dart';
import 'user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Offer {
  int? id;
  int? price;
  String? name;
  String? description;
  String? logement_type;
  String? trading_type;
  String? date_start;
  String? date_end;
  int? bed;
  int? rooms;
  int? visitors;
  int? bathroom;
  int? views_nm;
  int? agency_id;
  double? latitude;
  double? longitude;
  String? image;
  String? location;
  bool? selfLiked;
  User? user;

  Offer(
      {this.id,
      this.price,
      this.name,
      this.image,
      this.location,
      this.selfLiked,
      this.user,
      this.bathroom,
      this.bed,
      this.date_end,
      this.date_start,
      this.description,
      this.latitude,
      this.longitude,
      this.logement_type,
      this.rooms,
      this.trading_type,
      this.visitors,
      this.views_nm,
      this.agency_id});

// map json to post model

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
        id: json['id'],
        name: json['name'],
        bathroom: json['bathroom'],
        bed: json['bed'],
        rooms: json['rooms'],
        trading_type: json['trading_type'],
        latitude: json['latitude'],
        logement_type: json['logement_type'],
        longitude: json['longitude'],
        views_nm: json['views_nm'],
        visitors: json['visitors'],
        description: json['description'],
        date_end: json['date_end'],
        date_start: json['date_start'],
        price: json['price'],
        image: json['image'],
        agency_id: json['agency_id'],
        location: json['location'],
        selfLiked: json['likes'].length > 0,
        user: User(
          id: json['user']['id'],
          name: json['user']['name'],
        ));
  }
}

class Favorite {
  int? id;
  int? price;
  String? name;
  String? image;
  String? location;
  bool selfLiked = true;
  User? user;

  Favorite({
    this.id,
    this.price,
    this.name,
    this.image,
    this.location,
    required this.selfLiked,
    this.user,
  });

// map json to post model

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      location: json['location'],
      selfLiked: true,
    );
  }
}

// get all Offers
Future<ApiResponse> getOffers() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .get(Uri.parse('$url/offer'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['offers'];
        apiResponse.data as List<dynamic>;
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

// get Offer Details
Future<ApiResponse> getDetailsOffer(int offerId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
        Uri.parse('$url/offer/$offerId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['offer'];
        print(apiResponse.data);
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

// Create offer
Future<ApiResponse> createPost(String body, String? image) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
        Uri.parse('$url/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: image != null ? {'body': body, 'image': image} : {'body': body});

    // here if the image is null we just send the body, if not null we send the image too

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Edit offer
Future<ApiResponse> editOffer(int id, String body) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .patch(Uri.parse('$url/user/$id'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'body': body
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
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

updateData(data) async {
  String token = await getToken();
  return await http.post(Uri.parse('$url/offer'),
      body: jsonEncode(data),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
}

// Delete offer
Future<ApiResponse> deleteOffer(int Id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(
        Uri.parse('$url/offer/$Id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        print(apiResponse.data.toString());
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.statusCode);
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  print(apiResponse.data);
  return apiResponse;
}

Future<ApiResponse> deleteOfferPhotos(int Id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(
        Uri.parse('$url/photo/$Id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        print(apiResponse.data.toString());
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

// Like or unlike offer
Future<ApiResponse> likeUnlikeOffer(int offerId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
        Uri.parse('$url/offer/$offerId/likes'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        print(apiResponse.data.toString());
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        print('oooooooo');
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Dislike offer
Future<ApiResponse> UnlikeOffer(int offerId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(
        Uri.parse('$url/offer/$offerId/unlikes'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
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

//List Favorites
Future<ApiResponse> getFavorites() async {
  ApiResponse apiResponse = ApiResponse();

  String token = await getToken();

  final response = await http
      .get(Uri.parse('$url/likes'), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });

  switch (response.statusCode) {
    case 200:
      apiResponse.data = jsonDecode(response.body);
      print(200);
      break;
    case 401:
      apiResponse.error = unauthorized;
      break;
    default:
      apiResponse.error = somethingWentWrong;
      break;
  }

  return apiResponse;
}

//create Offer images
offerImage(List images, offer_id) async {
  var fullUrl = '$url/photo';
  String token = await getToken();
  Map<String, String> headers = {
    'Content-Type': 'multipart/form-data',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  };
  var request = http.MultipartRequest('POST', Uri.parse(fullUrl))
    ..headers.addAll(headers)
    ..fields['offer_id'] = offer_id.toString();
  for (int i = 0; i < images.length; i++) {
    print('hh   ${images[i]}');
    request.files.add(await http.MultipartFile.fromPath('$i', images[i]));
  }
  Images.listImage.clear();
  Images.listPath.clear();
  return await request.send();
}

//get Offer ID
getOfferID() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http
        .get(Uri.parse('$url/get/id'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['id'];
        print(apiResponse.data);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = response.statusCode.toString();
        break;
    }
  } catch (e) {
    apiResponse.error = somethingWentWrong;
  }
  return apiResponse;
}

//get Agency offers
Future<ApiResponse> getAgencyOffers() async {
  ApiResponse apiResponse = ApiResponse();

  String token = await getToken();

  final response = await http
      .get(Uri.parse('$url/agency'), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });

  switch (response.statusCode) {
    case 200:
      apiResponse.data = jsonDecode(response.body);
      print(200);
      break;
    case 401:
      apiResponse.error = unauthorized;
      break;
    default:
      apiResponse.error = somethingWentWrong;
      break;
  }

  return apiResponse;
}

//get Agency number
Future<ApiResponse> num(id) async {
  ApiResponse apiResponse = ApiResponse();

  String token = await getToken();

  final response = await http.get(
      Uri.parse('$url/agencyPhone/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

  switch (response.statusCode) {
    case 200:
      apiResponse.data = jsonDecode(response.body);
      apiResponse.data as List;
      print(apiResponse.data);
      break;
    case 401:
      apiResponse.error = unauthorized;
      break;
    default:
      apiResponse.error = somethingWentWrong;
      break;
  }

  return apiResponse;
}


//get offer images
Future<ApiResponse> getImages(int id) async {
  ApiResponse apiResponse = ApiResponse();
  String token = await getToken();

  final response = await http.get(Uri.parse('$url/photo/$id'), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });

  switch (response.statusCode) {
    case 200:
      apiResponse.data = jsonDecode(response.body);
      apiResponse.data as List;
      break;
    case 401:
      apiResponse.error = unauthorized;
      break;
    default:
      apiResponse.error = somethingWentWrong;
      break;
  }

  return apiResponse;
}
