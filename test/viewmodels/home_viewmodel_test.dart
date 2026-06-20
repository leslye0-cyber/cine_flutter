import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cine_flutter/data/repositories/movie_repository.dart';
import 'package:cine_flutter/data/models/movie.dart';
import 'package:cine_flutter/data/models/genre.dart';
import 'package:cine_flutter/presentation/viewmodels/home_viewmodel.dart';

import 'home_viewmodel_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late MockMovieRepository mockRepo;
  late HomeViewModel vm;

  final fakeMovies = [
    Movie(
      id: 1, title: 'Test Film', originalTitle: 'Test Film',
      overview: 'Un film de test', releaseDate: '2024-01-01',
      voteAverage: 8.0, voteCount: 1000, genreIds: [28],
    ),
  ];

  final fakeGenres = [
    Genre(id: 28, name: 'Action'),
    Genre(id: 35, name: 'Comédie'),
  ];

  setUp(() {
    mockRepo = MockMovieRepository();
    when(mockRepo.getPopularMovies()).thenAnswer((_) async => fakeMovies);
    when(mockRepo.getTrendingMovies()).thenAnswer((_) async => fakeMovies);
    when(mockRepo.getUpcomingMovies()).thenAnswer((_) async => fakeMovies);
    when(mockRepo.getGenres()).thenAnswer((_) async => fakeGenres);
  });

  test('loadInitialData charge les films et genres', () async {
    vm = HomeViewModel(mockRepo);
    await Future.delayed(const Duration(milliseconds: 100));

    expect(vm.state, ViewState.loaded);
    expect(vm.popularMovies.length, 1);
    expect(vm.genres.length, 2);
  });

  test('loadInitialData passe en error si exception', () async {
    when(mockRepo.getPopularMovies()).thenThrow(Exception('Erreur réseau'));
    vm = HomeViewModel(mockRepo);
    await Future.delayed(const Duration(milliseconds: 100));

    expect(vm.state, ViewState.error);
    expect(vm.errorMessage, isNotNull);
  });

  test('loadByGenre charge les films du genre', () async {
    when(mockRepo.getMoviesByGenre(28)).thenAnswer((_) async => fakeMovies);
    vm = HomeViewModel(mockRepo);
    await Future.delayed(const Duration(milliseconds: 100));

    await vm.loadByGenre(28);
    expect(vm.genreMovies.length, 1);
  });
}
