import 'package:flutter/material.dart';

const _accent = Color(0xFF2196F3); // remplace par ta couleur bleue exacte si differente
const _black = Color(0xFF0A0A0A);
const _card = Color(0xFF1A1A1A);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _black,
      appBar: AppBar(
        backgroundColor: _black,
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const ListTile(
              leading: Icon(Icons.movie_outlined, color: _accent),
              title: Text('CineFlutter', style: TextStyle(color: Colors.white)),
              subtitle: Text(
                'Catalogue de films et series',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(10),
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
    );
  }
}