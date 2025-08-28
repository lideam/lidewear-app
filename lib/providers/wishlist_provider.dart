import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/wishlist_service.dart';

class WishlistProvider with ChangeNotifier {
  final WishlistService _wishlistService = WishlistService();

  List<Product> _wishlist = [];
  List<Product> get wishlist => _wishlist;

  Future<void> fetchWishlist(String token) async {
    _wishlist = await _wishlistService.getWishlist(token);
    notifyListeners();
  }

  Future<void> toggleProduct(String productId, String token) async {
    _wishlist = await _wishlistService.toggleWishlist(productId, token);
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _wishlist.any((p) => p.id == productId);
  }
}
