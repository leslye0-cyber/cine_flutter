import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/circular_movie_card.dart';
import '../widgets/movie_card_netflix.dart';

const _pink =
Color(0xFF4FC3F7);
const _black = Color(0xFF0A0A0A);

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'A venir',
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
          vm.upcomingMovies.isEmpty
              ? const Center(
            child: CircularProgressIndicator(color: _pink),
          )
              : ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Prochaines sorties',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 130,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: vm.upcomingMovies.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (_, i) =>
                      CircularMovieCard(movie: vm.upcomingMovies[i]),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Toutes les sorties a venir',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.55,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: vm.upcomingMovies.length,
                itemBuilder: (_, i) =>
                    MovieCardNetflix(movie: vm.upcomingMovies[i]),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ],
      ),
    );
  }
}