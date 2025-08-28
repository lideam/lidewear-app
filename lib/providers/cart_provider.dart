import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();

  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.values.fold(
      0.0,
      (sum, item) => sum + item.price * item.quantity,
    );
  }

  /// ✅ Load cart from backend
  Future<void> loadCart(String token) async {
    final cartItems = await _cartService.fetchCart(token);
    _items = {for (var item in cartItems) item.cartItemId: item};
    notifyListeners();
  }

  /// ✅ Add to cart
  Future<void> addToCart(String productId, String token) async {
    await _cartService.addToCart(productId, token);
    await loadCart(token); // refresh after add
  }

  /// ✅ Remove from cart
  Future<void> removeItem(String cartItemId, String token) async {
    await _cartService.removeFromCart(cartItemId, token);
    _items.remove(cartItemId);
    notifyListeners();
  }

  /// ✅ Clear cart
  Future<void> clearCart(String token) async {
    await _cartService.clearCart(token);
    _items.clear();
    notifyListeners();
  }
}
