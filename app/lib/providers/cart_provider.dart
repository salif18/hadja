import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:hadja_grish/models/cart_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  List<CartItemModel> _cart;
  int _total;

  CartProvider()
      : _cart = [],
        _total = 0 {
    loadCartFromLocalStorage();
  }

  List<CartItemModel> get myCart => _cart;
  int get total => calculateTotal();

  // add
  void addToCart(ArticlesModel article, int newQty) {
    // Vérifier si le produit est déjà dans le panier
    final itemIsExist = _cart
        .firstWhereOrNull((item) => item.productId.contains(article.id.toString()));
    // Si c'est le cas, modifier seulement la quantité existante
    if (itemIsExist != null) {
      itemIsExist.qty += newQty;
    } else {
      // Sinon, ajouter le nouveau produit
      _cart.add(CartItemModel(
          productId: article.id.toString(),
          name: article.name,
          img: article.img,
          qty: newQty,
          prix: article.price * newQty));
    }
    // Réinitialiser à 0 après l'ajout
    newQty = 0;
    saveCartToLocalStorage();
    // Informer les auditeurs (les widgets) du changement
    notifyListeners();
  }

  // fonction suppression du produit dans le panier
  void removeToCart(CartItemModel item) {
    _cart.removeWhere((cartItem) => cartItem.productId == item.productId);
    saveCartToLocalStorage();
    notifyListeners();
  }

  // Increment
  void increment(CartItemModel article) {
    final newCart =
        _cart.map((cartItem) => article.productId == cartItem.productId
            ? CartItemModel(
                productId: cartItem.productId,
                name: cartItem.name,
                img: cartItem.img,
                qty: cartItem.qty + 1,
                prix: cartItem.prix,
              )
            : cartItem);
    _cart = newCart.toList();
    saveCartToLocalStorage();
    notifyListeners();
  }

  // Decrement
  void decrement(CartItemModel article) {
    final newCart = _cart.map((cartItem) =>
        cartItem.productId == article.productId && cartItem.qty > 1
            ? CartItemModel(
                productId: cartItem.productId,
                name: cartItem.name,
                img: cartItem.img,
                qty: cartItem.qty - 1,
                prix: cartItem.prix,
              )
            : cartItem);
    _cart = newCart.toList();
    saveCartToLocalStorage();
    notifyListeners();
  }

  int calculateTotal() {
    if (_cart.isNotEmpty) {
      _total = _cart
          .map((cartItem) => cartItem.qty * cartItem.prix)
          .reduce((a, b) => a + b);
    } else {
      _total = 0;
    }
    return _total;
  }

  Future<void> saveCartToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = _cart.map((item) => item.toJson()).toList();
    await prefs.setString("cart", jsonEncode(cartJson));
  }

  Future<void> loadCartFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJsonString = prefs.getString("cart");
    if (cartJsonString != null) {
      final cartJson = jsonDecode(cartJsonString) as List;
      _cart = cartJson
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
  }

  
  // fonction pour vider le panier
  void clearCart() {
    _cart.clear();
    saveCartToLocalStorage();
    notifyListeners();
  }
}
