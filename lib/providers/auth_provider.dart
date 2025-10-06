import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;
  String? _userId;
  String? _name;
  String? _email;
  bool _isInitialized = false;
  String? _lastOrderId;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  String? get userId => _userId;
  String? get name => _name;
  String? get email => _email;
  bool get isInitialized => _isInitialized;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  String? get lastOrderId => _lastOrderId;
  set lastOrderId(String? value) {
    _lastOrderId = value;
    notifyListeners();
  }

  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");
    _name = prefs.getString("name");
    _email = prefs.getString("email");
    _lastOrderId = prefs.getString("lastOrderId");

    if (_token != null && _token!.isNotEmpty) {
      _isAuthenticated = true;
    }
    _isInitialized = true;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      final url = Uri.parse("${dotenv.env['API_BASE_URL']}/auth/login");

      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _token = data["token"];
        _userId = data["user"]["_id"];
        _name = data["user"]["name"];
        _email = data["user"]["email"];
        _isAuthenticated = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", _token!);
        await prefs.setString("name", _name ?? "");
        await prefs.setString("email", _email ?? "");

        notifyListeners();
        return true;
      } else {
        debugPrint("Login failed: ${res.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Login error: $e");
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    try {
      final url = Uri.parse("${dotenv.env['API_BASE_URL']}/auth/register");

      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      if (res.statusCode == 201) {
        final data = jsonDecode(res.body);
        _token = data["token"];
        _userId = data["user"]["_id"];
        _name = data["user"]["name"];
        _email = data["user"]["email"];
        _isAuthenticated = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", _token!);
        await prefs.setString("name", _name ?? "");
        await prefs.setString("email", _email ?? "");

        notifyListeners();
        return true;
      } else {
        debugPrint("Signup failed: ${res.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Signup error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _token = null;
    _userId = null;
    _name = null;
    _email = null;
    _lastOrderId = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("name");
    await prefs.remove("email");
    await prefs.remove("lastOrderId");

    notifyListeners();
  }
}
