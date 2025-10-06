import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/cart_item.dart';

class CartService {
  final String _baseUrl = dotenv.env['API_BASE_URL']!;

  Future<List<CartItem>> fetchCart(String token) async {
    final url = Uri.parse("$_baseUrl/cart");
    final res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body);

      List<CartItem> items = [];
      for (var item in data["items"]) {
        items.add(
          CartItem(
            cartItemId: item["_id"],
            productId: item["product"]["_id"],
            name: item["product"]["name"],
            quantity: item["quantity"],
            price: (item["product"]["price"] as num).toDouble(),
            imageUrl: item["product"]["imageUrl"],
          ),
        );
      }
      return items;
    } else {
      throw Exception("Failed to fetch cart: ${res.body}");
    }
  }

  Future<void> addToCart(String productId, String token) async {
    final url = Uri.parse("$_baseUrl/cart");
    final res = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode({"productId": productId, "quantity": 1}),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to add to cart: ${res.body}");
    }
  }

  Future<void> removeFromCart(String cartItemId, String token) async {
    final url = Uri.parse("$_baseUrl/cart/$cartItemId");
    final res = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to remove from cart: ${res.body}");
    }
  }

  Future<void> clearCart(String token) async {
    final url = Uri.parse("$_baseUrl/cart/clear");
    final res = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to clear cart: ${res.body}");
    }
  }
}
