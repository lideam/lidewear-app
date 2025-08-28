# 📱 LideWear App

LideWear is a modern **Flutter-based e-commerce mobile app** built to
provide a smooth shopping experience with features like product
browsing, cart management, wishlists, and order checkout.

---

## 🚀 Features

- 🛍️ Product listing & details\
- ❤️ Wishlist support\
- 🛒 Shopping cart with checkout\
- 🔑 User authentication (signup/login)\
- 🎨 Light & Dark theme toggle\
- 📦 Order history\
- 🔗 API integration with backend (Node.js + MongoDB)

---

## 📂 Project Structure

    lib/
    ├── models/
    │   ├── cart_item.dart
    │   ├── order.dart
    │   └── product.dart
    ├── services/
    │   ├── product_service.dart
    │   └── cart_service.dart
    ├── providers/
    │   ├── auth_provider.dart
    │   ├── cart_provider.dart
    │   ├── product_provider.dart
    │   ├── wishlist_provider.dart
    │   └── theme_provider.dart
    ├── screens/
    │   ├── cart_screen.dart
    │   ├── checkout_screen.dart
    │   ├── favorites_screen.dart
    │   ├── home_screen.dart
    │   ├── login_screen.dart
    │   ├── product_detail_screen.dart
    │   ├── signup_screen.dart
    │   ├── main_screen.dart
    │   ├── profile_screen.dart
    │   └── test_connection_screen.dart
    ├── widgets/
    │   └── product_card.dart
    └── main.dart

---

## 🛠️ Installation

1.  Clone the repo:

    ```bash
    git clone https://github.com/<your-username>/LideWear-App.git
    cd LideWear-App
    ```

2.  Install dependencies:

    ```bash
    flutter pub get
    ```

3.  Configure environment variables:\
    Create a `.env` file at the root:

    ```env
    API_URL=https://your-backend-url.com/api
    ```

4.  Run the app:

    ```bash
    flutter run
    ```

---

## 📦 Dependencies

- `provider` -- State management\
- `http` -- API requests\
- `shared_preferences` -- Local storage\
- `flutter_dotenv` -- Env variables\
- `url_launcher` -- External links\
- `app_links` -- Deep linking\
- `flutter_native_splash` -- Splash screen\
- `flutter_launcher_icons` -- App icons

---

## 📜 License

MIT License © 2025 \[Lidetu Amare\]
