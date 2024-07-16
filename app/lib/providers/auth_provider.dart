import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier{
  //DECLARATION DES VARIABLES GLOBALS
  late String _token;
  late String _userId;

  //METHODE DE RECUPERATION AVEC FUTUREBUILD
  Future<String?> userId() async => await loadFromLocalStorage("userId");
  Future<String?> token() async => await loadFromLocalStorage("token");

  //INITIALISATION DES VARIABLES
  AuthProvider()
      : _token = "",
        _userId = "";

  //save to localstorage
  Future<void> saveToLocalStorage(String key, String value) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(key, value);
  }

  //load to localstorage
  Future<String?> loadFromLocalStorage(String key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    final data = localStorage.getString(key);
    if (data != null) {
      return data;
    } else {
      return null;
    }
  }

  //remove to localstorage
  Future<void> removeToLocalStorage(String key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.remove(key);
  }

  //get userId and token in login
  void loginButton(String userToken, String userUserId) {
    _token = userToken;
    _userId = userUserId;
    saveToLocalStorage("token", _token);
    saveToLocalStorage("userId", _userId);
    notifyListeners();
  }

  //deconnecter et supprimer userid et token
  void logoutButton() {
    _token = "";
    removeToLocalStorage("token");
    removeToLocalStorage("userId");
    removeToLocalStorage("profil");
    notifyListeners();
  }
}