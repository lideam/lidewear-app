import 'package:flutter/foundation.dart';

class CartItem {
  final String cartItemId;
  final String productId;
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

  Map<String, dynamic> toJson() {
    return {"product": productId, "quantity": quantity, "price": price};
  }
}
