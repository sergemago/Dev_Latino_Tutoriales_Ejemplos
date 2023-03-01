import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier{
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  void login(String username, String password) {
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

}