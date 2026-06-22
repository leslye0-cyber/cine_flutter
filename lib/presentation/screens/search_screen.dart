import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../viewmodels/search_viewmodel.dart';
import '../../data/services/local/prefs_service.dart';
import '../../data/models/tv_show.dart';
import '../widgets/movie_card.dart';
import '../../core/constants/app_constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();
    final prefs = context.watch<PrefsService>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          controller: _ctrl,
          decoration: InputDecoration(
            hintText: 'Films, séries...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            suffixIcon: _ctrl.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _ctrl.clear();
                vm.clear();
                setState(() {});
              },
            )
                : null,
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (q) {
            setState(() {});
            vm.onQueryChanged(q);
          },
        ),
        actions: [
          // 🎤 Bouton microphone
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                vm.isListening ? Icons.mic : Icons.mic_none,
                key: ValueKey(vm.isListening),
                color: vm.isListening ? Color(0xFF4FC3F7) : Colors.white,
              ),
            ),
            onPressed: vm.isListening
                ? vm.stopListening
                : () => vm.startListening((words) {
              setState(() => _ctrl.text = words);
            }),
          ),
        ],
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
          Column(
            children: [
              // Indicateur vocal
              if (vm.isListening)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: const Color(0xFF4FC3F7).withOpacity(0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.mic, color: Color(0xFF4FC3F7), size: 16),
                      const SizedBox(width: 8),
                      Text(vm.voiceStatus,
                          style: const TextStyle(color: Color(0xFF4FC3F7), fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),

              // Filtres Films / Séries / Tout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Tout',
                      selected: vm.searchType == SearchType.all,
                      onTap: () => vm.setSearchType(SearchType.all),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: '🎬 Films',
                      selected: vm.searchType == SearchType.movies,
                      onTap: () => vm.setSearchType(SearchType.movies),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: '📺 Séries',
                      selected: vm.searchType == SearchType.tvShows,
                      onTap: () => vm.setSearchType(SearchType.tvShows),
                    ),
                  ],
                ),
              ),

              // Contenu
              Expanded(
                child: vm.currentQuery.isEmpty
                    ? _buildHistory(prefs, vm)
                    : vm.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : vm.error != null
                    ? Center(child: Text(vm.error!))
                    : !vm.hasResults
                    ? const Center(child: Text('Aucun résultat'))
                    : _buildResults(vm),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistory(PrefsService prefs, SearchViewModel vm) {
    if (prefs.searchHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text('Recherchez un film ou une série',
                style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text('Ou utilisez le 🎤 microphone',
                style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recherches récentes',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              TextButton(onPressed: prefs.clearHistory, child: const Text('Effacer')),
            ],
          ),
        ),
        ...prefs.searchHistory.map((q) => ListTile(
          leading: const Icon(Icons.history, size: 20),
          title: Text(q),
          onTap: () {
            _ctrl.text = q;
            setState(() {});
            vm.onQueryChanged(q);
          },
          trailing: const Icon(Icons.north_west, size: 16),
        )),
      ],
    );
  }

  Widget _buildResults(SearchViewModel vm) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Section Films
        if (vm.movieResults.isNotEmpty) ...[
          const Text('🎬 Films',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: vm.movieResults.length,
            itemBuilder: (_, i) =>
                MovieCard(movie: vm.movieResults[i], width: double.infinity, height: 220),          ),
          const SizedBox(height: 24),
        ],

        // Section Séries
        if (vm.tvResults.isNotEmpty) ...[
          const Text('📺 Séries',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: vm.tvResults.length,
            itemBuilder: (_, i) => _TvShowCard(tvShow: vm.tvResults[i]),
          ),
        ],
      ],
    );
  }
}

class _TvShowCard extends StatelessWidget {
  final TvShow tvShow;
  const _TvShowCard({required this.tvShow});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: AppConstants.posterUrl(tvShow.posterPath),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.tv, color: Colors.grey, size: 40),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Color(0xFFF0A500), size: 12),
                        const SizedBox(width: 2),
                        Text(tvShow.ratingFormatted,
                            style: const TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('SÉRIE',
                        style: TextStyle(color: Colors.white, fontSize: 9,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Text(tvShow.name, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          Text(tvShow.year,
              style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          border: Border.all(color: selected ? color : Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}