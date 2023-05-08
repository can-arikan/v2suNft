import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import "../models/User.dart";

class UserProvider with ChangeNotifier {
  User? _user;
  bool _loading = false;

  User? get user => _user;
  bool get loading => _loading;

  Future<bool> logout() async {
    _user = null;
    _loading = true;
    notifyListeners();
    var prefs = await SharedPreferences.getInstance();
    prefs.remove("refreshToken");
    _loading = false;
    notifyListeners();
    return _user == null;
  }

  Future<void> setUser(User user) async {
    _user = user;
    notifyListeners();
  }

  void likeNFT(){
    _user!.nftLikes += 1;
    notifyListeners();
  }
  void dislikeNFT(){
    _user!.nftLikes -= 1;
    notifyListeners();
  }
}