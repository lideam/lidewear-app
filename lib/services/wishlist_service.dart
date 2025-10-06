import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/product.dart';

class WishlistService {
  final String baseUrl = "${dotenv.env['API_BASE_URL']}/wishlist";

  Future<List<Product>> getWishlist(String token) async {
    print("📥 Fetching wishlist from: $baseUrl");
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("➡️ GET /wishlist response: ${response.statusCode} ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load wishlist: ${response.body}");
    }
  }

  Future<List<Product>> toggleWishlist(String productId, String token) async {
    print("🔄 Toggling product $productId in wishlist @ $baseUrl");

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({"productId": productId}),
    );

    print(
      "➡️ POST /wishlist response: ${response.statusCode} ${response.body}",
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Failed to update wishlist: ${response.body}");
    }
  }
}
