import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    final apiBase = dotenv.env['API_BASE_URL'] ?? '';
    final url = Uri.parse('$apiBase/products');

    print("📡 Fetching products from: $url");

    try {
      final response = await http.get(url);
      print("📡 Status code: ${response.statusCode}");
      print("📡 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Error fetching products: $e");
      throw Exception('Error fetching products: $e');
    }
  }
}
