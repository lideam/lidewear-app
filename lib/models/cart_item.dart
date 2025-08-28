import 'package:flutter/foundation.dart';

class CartItem {
  final String cartItemId; // Backend cart item _id
  final String productId; // Product's _id
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    required this.cartItemId,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  // ✅ Convert CartItem → JSON for backend order request
  Map<String, dynamic> toJson() {
    return {
      "product": productId, // backend only needs product ID
      "quantity": quantity,
      "price": price,
    };
  }
}
