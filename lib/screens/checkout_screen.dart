import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../services/order_service.dart';
import '../models/order.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final OrderService _orderService = OrderService();
  String? checkoutUrl;
  String? txRef; // 👈 store transaction reference
  bool isLoading = false;

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (navReq) async {
            // 👀 detect success page
            if (navReq.url.contains("/success")) {
              final auth = Provider.of<AuthProvider>(context, listen: false);

              try {
                // ✅ Verify & update order after success
                await _orderService.verifyPayment(
                  auth.token!,
                  auth.lastOrderId!, // you can save last orderId in AuthProvider
                  txRef!, // tx_ref from initiatePayment
                );

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Payment Successful ✅")),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("❌ Verification failed: $e")),
                );
              }

              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  Future<void> _startPayment() async {
    setState(() => isLoading = true);

    final cart = Provider.of<CartProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    try {
      // Step 1: Create order
      Order order = await _orderService.createOrder(
        auth.token!,
        cart.items.values.toList(),
        cart.totalAmount,
      );

      // Save last order ID in auth (or state mgmt)
      auth.lastOrderId = order.id;

      // Step 2: Init payment
      final paymentInit = await _orderService.initiatePayment(
        auth.token!,
        order.id,
      );

      setState(() {
        checkoutUrl = paymentInit["checkout_url"]; // 👈 fix here
        txRef = paymentInit["tx_ref"]; // 👈 save tx_ref
        isLoading = false;
      });

      // ✅ Load WebView
      _controller.loadRequest(Uri.parse(checkoutUrl!));
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Payment error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : checkoutUrl == null
          ? Center(
              child: ElevatedButton(
                onPressed: _startPayment,
                child: const Text("Pay with Chapa"),
              ),
            )
          : WebViewWidget(controller: _controller),
    );
  }
}
