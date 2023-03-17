import 'package:cloud_firestore/cloud_firestore.dart';
import '../resources/auth_methods.dart';

class Post {
  final String description;
  final String title;
  final String username;
  final String uid;
  final String quantity;
  final String postId;
  final String profUrl;
  final String postUrl;
  final String datePublished;
  final likes;
  final bool isVeg;
  final bool isEvent;
  final double latitude;
  final double longitude;

  const Post({
    required this.description,
    required this.title,
    required this.username,
    required this.quantity,
    required this.uid,
    required this.postId,
    required this.profUrl,
    required this.postUrl,
    required this.datePublished,
    required this.likes,
    required this.isVeg,
    required this.isEvent,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "title": title,
        "username": username,
        "uid": uid,
        "postId": postId,
        "profUrl": profUrl,
        "quantity": quantity,
        "postUrl": postUrl,
        "datePublished": datePublished,
        "likes": likes,
        "isVeg": isVeg,
        "isEvent": isEvent,
        "latitude": latitude,
        "longitude": longitude,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot['description'],
      title: snapshot['title'],
      username: snapshot['username'],
      uid: snapshot['uid'],
      postId: snapshot['postId'],
      profUrl: snapshot['profUrl'],
      quantity: snapshot['quantity'],
      postUrl: snapshot['postUrl'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
      isVeg: snapshot['isVeg'],
      isEvent: snapshot['isEvent'],
      latitude: snapshot['latitude'],
      longitude: snapshot['longitude'],
    );
  }
}
