import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 User Info
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    child: Text(
                      (auth.name?.isNotEmpty ?? false)
                          ? auth.name![0].toUpperCase()
                          : "?",
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    auth.name ?? "Guest User",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    auth.email ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 🔹 Appearance
            Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark Mode', style: TextStyle(fontSize: 18)),
                Switch(
                  value: themeProvider.currentTheme == ThemeMode.dark,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
              ],
            ),

            const Spacer(),

            // 🔹 Logout button
            if (auth.isLoggedIn)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    auth.logout();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
