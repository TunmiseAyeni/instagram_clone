import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/models/user.dart' as model;
// import 'package:flutter/material.dart';

class Authentication {
  final firebaseAuth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
  final fbStorage = FirebaseStorage.instance;
  final bool _isPost = false;

//getting the user details from the firestore so we can use it in the app
  Future<model.User> getUserDetails() async {
    final currentUser = firebaseAuth.currentUser!;

    final userData =
        await fireStore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnapToUser(userData);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List profileImage,
  }) async {
    String res = 'An error occured';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          profileImage.isNotEmpty) {
        final userCredentials = await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        //upload image to firestore
        final storageRef = fbStorage
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');
        //putting the image in the storage
        await storageRef.putData(profileImage);
        //getting the image url
        final imageUrl = await storageRef.getDownloadURL();

        //creating a user object
        model.User user = model.User(
          username: username,
          bio: bio,
          uid: userCredentials.user!.uid,
          imageUrl: imageUrl,
          userId: userCredentials.user!.uid,
          followers: [],
          following: [],
          email: email,
        );
        //adding the user to firestore
        await fireStore.collection('users').doc(userCredentials.user!.uid).set(
              user.toJson(),
            );
        res = 'success';
      } else {
        res = 'Please fill in all fields';
      }
    } catch (err) {
      //res is the error message
      res = err.toString();
    }
    return res;
  }

  //login user
  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    String res = 'An error occured';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please fill in all fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
