import 'package:flutter/material.dart';
import '../../data/models/genre.dart';

const _pink =
Color(0xFF4FC3F7);
const _card = Color(0xFF1A1A1A);
const _border = Color(0xFF2A2A2A);

class GenreFilterBar extends StatelessWidget {
  final List<Genre> genres;
  final Genre? selected;
  final Function(Genre?) onSelected;

  const GenreFilterBar({
    super.key,
    required this.genres,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _GenreChip(
            label: 'Tous',
            isSelected: selected == null,
            onTap: () => onSelected(null),
          ),
          ...genres.map(
                (g) => _GenreChip(
              label: g.name,
              isSelected: selected?.id == g.id,
              onTap: () => onSelected(selected?.id == g.id ? null : g),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenreChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _pink : _card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _pink : _border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontSize: 12,
            fontWeight:
            isSelected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}