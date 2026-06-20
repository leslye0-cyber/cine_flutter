import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cine_flutter/data/models/movie.dart';
import 'package:cine_flutter/presentation/widgets/movie_card.dart';

void main() {
  final movie = Movie(
    id: 1,
    title: 'Film Test',
    originalTitle: 'Film Test',
    overview: 'Test overview',
    releaseDate: '2024-06-01',
    voteAverage: 7.5,
    voteCount: 2000,
    genreIds: [28],
    posterPath: null,
  );

  testWidgets('MovieCard affiche le titre et la note', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MovieCard(movie: movie),
        ),
      ),
    );

    expect(find.text('Film Test'), findsOneWidget);
    expect(find.text('2024'), findsOneWidget);
    expect(find.text('7.5'), findsOneWidget);
  });

  testWidgets('MovieCard affiche icône favori si isFavorite', (tester) async {
    final favMovie = movie.copyWith(isFavorite: true);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MovieCard(movie: favMovie),
        ),
      ),
    );
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}