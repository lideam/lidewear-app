import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'; // ✅ Android impl
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'; // ✅ iOS impl

import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';

import 'screens/test_connection_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Load env variables
  await dotenv.load();

  // ✅ Initialize WebView platform
  if (WebViewPlatform.instance == null) {
    WebViewPlatform.instance = AndroidWebViewPlatform(); // Android
    WebViewPlatform.instance = WebKitWebViewPlatform(); // iOS
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer3<AuthProvider, CartProvider, ThemeProvider>(
        builder: (context, authProvider, cartProvider, themeProvider, _) {
          // ⏳ While restoring session
          if (!authProvider.isInitialized) {
            authProvider.restoreSession().then((_) {
              if (authProvider.isLoggedIn) {
                // Load cart
                cartProvider.loadCart(authProvider.token!);

                // Load wishlist
                Provider.of<WishlistProvider>(
                  context,
                  listen: false,
                ).fetchWishlist(authProvider.token!);
              }
            });

            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // ✅ App
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Fashion Store',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.currentTheme,
            home: const TestConnectionScreen(),
          );
        },
      ),
    );
  }
}
