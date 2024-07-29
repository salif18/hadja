import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hadja_grish/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfosProvider extends ChangeNotifier {

  //sauvegarder dans localstorage
  Future<void> saveToLocalStorage(ProfilModel data) async {
    final SharedPreferences storage = await SharedPreferences.getInstance(); 
    await storage.setString("profil", jsonEncode(data));
    notifyListeners();
  }

//load to localStorage
  Future<ProfilModel?> loadProfilFromLocalStorage() async {
  final SharedPreferences storage = await SharedPreferences.getInstance(); 
  final jsonData = storage.getString("profil");
  if (jsonData != null) {
    final decodedData = jsonDecode(jsonData);
    final profil = ProfilModel.fromJson(decodedData);
    return profil;
  } else {
    return null;
  }
 }

 @override
  notifyListeners();
}
