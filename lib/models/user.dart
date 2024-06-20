import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String bio;
  final String imageUrl;
  final String uid;
  final String userId;
  final List<String> followers;
  final List<String> following;
  final String email;

  User({
    required this.username,
    required this.bio,
    required this.uid,
    required this.imageUrl,
    required this.userId,
    required this.followers,
    required this.following,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'bio': bio,
        'followers': followers,
        'following': following,
        'user-id': uid,
        'imageUrl': imageUrl,
        'email': email,
      };

//converts a snapshot to a user object
  static User fromSnapToUser(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapshot['username'],
      bio: snapshot['bio'],
      uid: snapshot['uid'],
      imageUrl: snapshot['imageUrl'],
      userId: snapshot['userId'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      email: snapshot['email'],
    );
  }
}
