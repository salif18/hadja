import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  List<ArticlesModel> _favoriteArray;

  FavoriteProvider() : _favoriteArray = [] {
    loadFavoritesFromLocalStorage();
  }

  List<ArticlesModel> get getFavorites => _favoriteArray;

  void addMyFavorites(ArticlesModel article) {
    final existInFavorites = _favoriteArray.firstWhereOrNull(
        (favoriteItem) => favoriteItem.productId == article.productId);
    if (existInFavorites != null) {
      _favoriteArray.removeWhere((item) => item.productId == article.productId);
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
    final favoritesJson = _favoriteArray.map((item) => item.toJson()).toList();
    await prefs.setString("favorites", jsonEncode(favoritesJson));
  }

  Future<void> loadFavoritesFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJsonString = prefs.getString("favorites");
    if (favoritesJsonString != null) {
      final favoritesJson = jsonDecode(favoritesJsonString) as List;
      _favoriteArray = favoritesJson
          .map((item) => ArticlesModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    notifyListeners();
  }
}
