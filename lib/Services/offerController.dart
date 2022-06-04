// ignore_for_file: avoid_print, non_constant_identifier_names, file_names

import 'package:memoire/utils/constant.dart';
import 'package:memoire/widgets/input.dart';
import 'Api.dart';
import 'userController.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// get all Offers
Future<ApiResponse> getOffers() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('$url/offer'), headers: {
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

// get all Offers
Future<ApiResponse> getPopular() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('$url/random'), headers: {
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
    final response = await http.get(Uri.parse('$url/offer/$offerId'), headers: {
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
    final response = await http.post(Uri.parse('$url/user'),
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
    final response = await http.patch(Uri.parse('$url/user/$id'), headers: {
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
  return await http
      .post(Uri.parse('$url/offer'), body: jsonEncode(data), headers: {
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
    final response = await http.delete(Uri.parse('$url/offer/$Id'), headers: {
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
    final response = await http.delete(Uri.parse('$url/photo/$Id'), headers: {
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
    final response = await http.post(Uri.parse('$url/offer/$offerId/likes'),
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
    final response = await http.post(Uri.parse('$url/offer/$offerId/unlikes'),
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

  final response = await http.get(Uri.parse('$url/likes'), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });

  switch (response.statusCode) {
    case 200:
      apiResponse.data = jsonDecode(response.body);
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

//upload Offer images
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
    final response = await http.get(Uri.parse('$url/get/id'), headers: {
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

  final response = await http.get(Uri.parse('$url/agency'), headers: {
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

  final response = await http.get(Uri.parse('$url/agencyPhone/$id'), headers: {
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

//Search by Data
Future<ApiResponse> getOffersByData(data) async {
  ApiResponse apiResponse = ApiResponse();

  String token = await getToken();

  final response = await http.get(Uri.parse('$url/offer/search/$data'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

  switch (response.statusCode) {
    case 200:
      apiResponse.data = jsonDecode(response.body)['offers'];
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

//Search by Price
Future<ApiResponse> getOffersByPrice(min, max) async {
  ApiResponse apiResponse = ApiResponse();

  String token = await getToken();
  if (min == 0) {
    min = -1;
  }
  if (max == 0) {
    max = -1;
  }
  final response = await http.get(Uri.parse('$url/offer/search/$min/$max'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

  switch (response.statusCode) {
    case 200:
      apiResponse.data = jsonDecode(response.body)['offers'];
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

//Search by Price
Future<ApiResponse> getOffersOnMap() async {
  ApiResponse apiResponse = ApiResponse();
  String token = await getToken();
  final response = await http.get(Uri.parse('$url/offer/list/map'), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });

  switch (response.statusCode) {
    case 200:
      apiResponse.data = jsonDecode(response.body);
      apiResponse.data as List<dynamic>;
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
