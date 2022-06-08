import 'user.dart';

class Comment {
  int? id;
  String? comment;
  User? user;
  String? date;

  Comment({this.id, this.comment, this.user, this.date});

  // map json to comment model
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'],
        comment: json['comment'],
        date: json['created_at'],
        user: User(
            id: json['user']['id'],
            name: json['user']['name'],
            image: json['user']['image']));
  }
}
