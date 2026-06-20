import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:cine_flutter/data/repositories/movie_repository.dart';
import 'package:cine_flutter/data/models/movie.dart';
import 'package:cine_flutter/presentation/viewmodels/search_viewmodel.dart';

import 'search_viewmodel_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockMovieRepository mockRepo;
  late SearchViewModel vm;

  final fakeMovies = [
    Movie(
      id: 1,
      title: 'Avengers',
      originalTitle: 'Avengers',
      overview: 'Film action',
      releaseDate: '2019-01-01',
      voteAverage: 8.4,
      voteCount: 5000,
      genreIds: [28],
    ),
  ];

  setUp(() {
    mockRepo = MockMovieRepository();
    vm = SearchViewModel(mockRepo);
  });

  tearDown(() {
    vm.dispose();
  });

  test('clear réinitialise les résultats', () {
    vm.clear();

    expect(vm.movieResults, isEmpty);
    expect(vm.tvResults, isEmpty);
    expect(vm.currentQuery, isEmpty);
  });

  test('searchType par défaut est all', () {
    expect(vm.searchType, SearchType.all);
  });

  test('setSearchType change le type', () {
    vm.setSearchType(SearchType.movies);

    expect(vm.searchType, SearchType.movies);
  });
}