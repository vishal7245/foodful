import 'package:cloud_firestore/cloud_firestore.dart';
import '../resources/auth_methods.dart';

class User {
  final String email;
  final String username;
  final String uid;
  final String bio;
  final String photoUrl;
  final List followers;
  final List following;
  final double latitude;
  final double longitude;

  const User({
    required this.email,
    required this.username,
    required this.uid,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
        "latitude": latitude,
        "longitude": longitude,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      latitude: snapshot['latitude'],
      longitude: snapshot['longitude'],
    );
  }
}
