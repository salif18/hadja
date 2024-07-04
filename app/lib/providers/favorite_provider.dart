import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  List<ArticlesModel> _favoriteArray;

  FavoriteProvider() : _favoriteArray = [] {
    loadCartFromLocalStorage();
  }

  List<ArticlesModel> get getFavorites => _favoriteArray;

  void addMyFavorites(ArticlesModel article) {
    final existInfavorite = _favoriteArray.firstWhereOrNull(
        (favoriteItem) => favoriteItem.productId.contains(article.productId));
    if (existInfavorite != null) {
      _favoriteArray.removeWhere((item)=>item.productId == article.productId);
    } else {
      _favoriteArray.add(article);
    }
    saveToLocalStorage();
    notifyListeners();
  }

  void removeToFavorite(ArticlesModel article) {
    _favoriteArray.removeWhere(
        (favoriteItem) => favoriteItem.productId == article.productId);
    saveToLocalStorage();
    notifyListeners();
  }

  Future<void> saveToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = _favoriteArray.map((item) => item.toJson()).toList();
    await prefs.setString("favorites", jsonEncode(cartJson));
  }

  Future<void> loadCartFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJsonString = prefs.getString("favorites");
    if (cartJsonString != null) {
      final cartJson = jsonDecode(cartJsonString) as List;
      _favoriteArray = cartJson
          .map((item) => ArticlesModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
  }
}
