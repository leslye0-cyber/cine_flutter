import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/services/local/prefs_service.dart';

const _pink =
Color(0xFF4FC3F7);
const _black = Color(0xFF0A0A0A);
const _card = Color(0xFF1A1A1A);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<PrefsService>();
    final isDark = prefs.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/img.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.75),
            ),
          ),
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white10),
                ),
                child: ListTile(
                  leading: const Icon(Icons.dark_mode_outlined, color: Colors.white),
                  title: const Text('Mode sombre',
                      style: TextStyle(color: Colors.white)),
                  trailing: Switch(
                    value: isDark,
                    activeColor: _pink,
                    onChanged: (_) => prefs.toggleTheme(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white10),
                ),
                child: const ListTile(
                  leading: Icon(Icons.info_outline, color: Colors.white),
                  title: Text('A propos', style: TextStyle(color: Colors.white)),
                  subtitle: Text(
                    'CineFlutter v1.0 - Projet academique Flutter & TMDB',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}