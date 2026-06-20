import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/hero_banner.dart';
import '../widgets/movie_card_netflix.dart';
import '../widgets/circular_movie_card.dart';
import '../widgets/section_header.dart';
import '../widgets/genre_filter_bar.dart';
import '../../data/models/genre.dart';

// Couleurs rose et noir
const _pink = Color(0xFFE91E8C);
const _black = Color(0xFF0A0A0A);
const _card = Color(0xFF1A1A1A);
const _card2 = Color(0xFF232323);
const _border = Color(0xFF2A2A2A);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Genre? _selectedGenre;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<HomeViewModel>().loadMorePopular();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    return Scaffold(
      backgroundColor: _black,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: vm.state == ViewState.loading
          ? _buildLoading()
          : vm.state == ViewState.error
          ? _buildError(vm)
          : _buildContent(vm),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xCC000000), Colors.transparent],
          ),
        ),
      ),
      leading: const Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          'CINE',
          style: TextStyle(
            color: _pink,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text('Films',
              style: TextStyle(color: Colors.white, fontSize: 13)),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Series',
              style: TextStyle(color: Colors.white, fontSize: 13)),
        ),
        GestureDetector(
          onTap: () => context.go('/search'),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.search, color: Colors.white, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 520,
            decoration: const BoxDecoration(color: _card),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: 120,
              height: 18,
              decoration: BoxDecoration(
                color: _card2,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, __) =>
              const _SkeletonCard(width: 120, height: 180),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: 150,
              height: 18,
              decoration: BoxDecoration(
                color: _card2,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 130,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, __) => const _SkeletonCircle(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(HomeViewModel vm) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Connexion impossible',
              style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 8),
          Text(vm.errorMessage ?? '',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _pink),
            onPressed: vm.refresh,
            child: const Text('Reessayer',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(HomeViewModel vm) {
    return RefreshIndicator(
      color: _pink,
      backgroundColor: _card,
      onRefresh: vm.refresh,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: vm.trendingMovies.isNotEmpty
                ? HeroBanner(movie: vm.trendingMovies.first)
                : const SizedBox(height: 300),
          ),
          if (vm.trendingMovies.length > 1)
            SliverToBoxAdapter(
              child: _MyListSection(
                movies: vm.trendingMovies.skip(1).take(5).toList(),
              ),
            ),
          SliverToBoxAdapter(
            child: GenreFilterBar(
              genres: vm.genres,
              selected: _selectedGenre,
              onSelected: (g) {
                setState(() => _selectedGenre = g);
                if (g != null) vm.loadByGenre(g.id);
              },
            ),
          ),
          if (vm.upcomingMovies.isNotEmpty)
            SliverToBoxAdapter(
              child: _CircularSection(
                title: 'A venir',
                movies: vm.upcomingMovies,
              ),
            ),
          SliverToBoxAdapter(
            child: _HorizontalSection(
              title: 'Populaires',
              movies: _selectedGenre != null
                  ? vm.genreMovies
                  : vm.popularMovies,
            ),
          ),
          SliverToBoxAdapter(
            child: _HorizontalSection(
              title: 'Tendances',
              movies: vm.trendingMovies,
            ),
          ),
          SliverToBoxAdapter(
            child: _RecommendationsGrid(movies: vm.popularMovies),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final double width;
  final double height;
  const _SkeletonCard({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height + 38,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: _card2,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: width * 0.8,
            height: 10,
            decoration: BoxDecoration(
              color: _card2,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: width * 0.4,
            height: 10,
            decoration: BoxDecoration(
              color: _card2,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonCircle extends StatelessWidget {
  const _SkeletonCircle();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: _card2,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 70,
          height: 10,
          decoration: BoxDecoration(
            color: _card2,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

class _MyListSection extends StatelessWidget {
  final List movies;
  const _MyListSection({required this.movies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text('Ma Liste',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => MovieCardNetflix(
              movie: movies[i],
              width: 60,
              height: 90,
              showTitle: false,
            ),
          ),
        ),
      ],
    );
  }
}

class _CircularSection extends StatelessWidget {
  final String title;
  final List movies;
  const _CircularSection({required this.title, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        SizedBox(
          height: 130,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: movies.length.clamp(0, 10),
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, i) => CircularMovieCard(movie: movies[i]),
          ),
        ),
      ],
    );
  }
}

class _HorizontalSection extends StatelessWidget {
  final String title;
  final List movies;
  const _HorizontalSection({required this.title, required this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        SizedBox(
          height: 220,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => MovieCardNetflix(movie: movies[i]),
          ),
        ),
      ],
    );
  }
}

class _RecommendationsGrid extends StatefulWidget {
  final List movies;
  const _RecommendationsGrid({required this.movies});
  @override
  State<_RecommendationsGrid> createState() => _RecommendationsGridState();
}

class _RecommendationsGridState extends State<_RecommendationsGrid> {
  String _filter = 'Tout';
  final List<String> _filters = ['Tout', 'Action', 'Comedie', 'Horreur', 'Drame'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Recommandations'),
        SizedBox(
          height: 36,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final selected = _filter == _filters[i];
              return GestureDetector(
                onTap: () => setState(() => _filter = _filters[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected ? _pink : _card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? _pink : _border,
                    ),
                  ),
                  child: Text(
                    _filters[i],
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.grey,
                      fontSize: 12,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.62,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: widget.movies.length.clamp(0, 8),
          itemBuilder: (_, i) => MovieCardNetflix(
            movie: widget.movies[i],
            showRating: true,
            showPlayButton: true,
          ),
        ),
      ],
    );
  }
}