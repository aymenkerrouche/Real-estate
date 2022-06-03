
import 'user.dart';

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
