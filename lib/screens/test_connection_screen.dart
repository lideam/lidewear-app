import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'login_screen.dart'; // ✅ Import your Login screen

class TestConnectionScreen extends StatefulWidget {
  const TestConnectionScreen({super.key});

  @override
  State<TestConnectionScreen> createState() => _TestConnectionScreenState();
}

class _TestConnectionScreenState extends State<TestConnectionScreen> {
  String result = '🔄 Checking backend connection...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      testBackend();
    });
  }

  Future<void> testBackend() async {
    final baseUrl = dotenv.env['API_BASE_URL'];
    final url = Uri.parse('$baseUrl/products');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        setState(() => result = '✅ Success: Connected to backend!');
        await Future.delayed(
          const Duration(seconds: 1),
        ); // Small pause to show success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        setState(
          () => result = '❌ Failed: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      setState(() => result = '⚠️ Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backend Test')),
      body: Center(
        child: result.startsWith('🔄')
            ? const CircularProgressIndicator()
            : Text(result, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
