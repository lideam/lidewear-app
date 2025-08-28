import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:LideWear/models/order.dart';
import 'package:LideWear/models/cart_item.dart';

class OrderService {
  final String baseUrl = "https://c8aa2993ef26.ngrok-free.app/api/orders";

  /// Create an order
  Future<Order> createOrder(
    String token,
    List<CartItem> items,
    double totalAmount,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "items": items
            .map(
              (item) => {
                "product": item.productId, // backend expects `product`
                "quantity": item.quantity,
                "price": item.price,
              },
            )
            .toList(),
        "totalAmount": totalAmount,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data is Map && data.containsKey("order")) {
        return Order.fromJson(data["order"]);
      } else {
        return Order.fromJson(data);
      }
    } else {
      throw Exception("❌ Failed to create order: ${response.body}");
    }
  }

  /// Initiate Chapa Payment
  Future<Map<String, dynamic>> initiatePayment(
    String token,
    String orderId,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$orderId/pay/init"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data["checkout_url"] != null) {
        return {
          "checkout_url": data["checkout_url"],
          "tx_ref": data["tx_ref"], // 👈 keep this for verify step
        };
      } else {
        throw Exception("⚠️ No checkout_url in response: ${response.body}");
      }
    } else {
      throw Exception("❌ Failed to init payment: ${response.body}");
    }
  }

  /// Verify & confirm payment (client-side)
  Future<Order> verifyPayment(
    String token,
    String orderId,
    String txRef,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$orderId/pay"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "status": "success", // ✅ force success for testing
        "method": "Chapa",
        "tx_ref": txRef,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Order.fromJson(data["order"]);
    } else {
      throw Exception("❌ Failed to verify payment: ${response.body}");
    }
  }

  /// ✅ Fetch all orders for logged-in user
  Future<List<Order>> fetchUserOrders(String token) async {
    final response = await http.get(
      Uri.parse("http://10.28.202.76:5000/api/orders"), // for Android Emulator
      // or use your local network IP if testing on real device, e.g. http://192.168.1.5:5000/api/orders
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List) {
        return data.map((json) => Order.fromJson(json)).toList();
      } else if (data is Map && data["orders"] != null) {
        return (data["orders"] as List)
            .map((json) => Order.fromJson(json))
            .toList();
      } else {
        throw Exception("⚠️ Unexpected response: $data");
      }
    } else {
      throw Exception("❌ Failed to fetch orders: ${response.body}");
    }
  }
}
