
// ignore_for_file: non_constant_identifier_names

import 'user.dart';

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
