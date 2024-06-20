import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/authentication.dart';

class UserProvider extends ChangeNotifier {
  model.User? _user;
  final _authMethods = Authentication();
//creating a getter to make sure user is not null
  model.User get getUser => _user!;

  // UserProvider() {
  //   refreshUser();
  // }
  Future<void> refreshUser() async {
    model.User user = await _authMethods.getUserDetails();
    _user = user;
    //to notify the listeners that the user has been updated
    notifyListeners();
  }
}
