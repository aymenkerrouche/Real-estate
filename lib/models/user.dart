
// ignore_for_file: prefer_typing_uninitialized_variables

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
