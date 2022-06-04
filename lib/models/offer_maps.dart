import 'package:google_maps_flutter/google_maps_flutter.dart';

class OfferMap {
  int? id;
  double? latitude;
  double? longitude;
  String? location;
  LatLng? adrs;
  String? name;

  OfferMap(
      {this.id,
      this.location,
      this.latitude,
      this.longitude,
      this.adrs,
      this.name});

// map json to post model

  factory OfferMap.fromJson(Map<String, dynamic> json) {
    return OfferMap(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      location: json['location'],
      name: json['name'],
    );
  }
}
