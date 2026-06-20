import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/services/local/prefs_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<PrefsService>();
    final isDark = prefs.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Mode sombre'),
            trailing: Switch(value: isDark, onChanged: (_) => prefs.toggleTheme()),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('À propos'),
            subtitle: const Text('CineFlutter v1.0 — Projet académique Flutter & TMDB'),
          ),
        ],
      ),
    );
  }
}