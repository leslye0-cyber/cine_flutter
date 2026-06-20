import 'package:hive/hive.dart';
import 'genre.dart';

part 'movie.g.dart';

@HiveType(typeId: 0)
class Movie extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String originalTitle;

  @HiveField(3)
  final String overview;

  @HiveField(4)
  final String? posterPath;

  @HiveField(5)
  final String? backdropPath;

  @HiveField(6)
  final String releaseDate;

  @HiveField(7)
  final double voteAverage;

  @HiveField(8)
  final int voteCount;

  @HiveField(9)
  final int? runtime;

  @HiveField(10)
  final List<int> genreIds;

  @HiveField(11)
  bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    this.runtime,
    required this.genreIds,
    this.isFavorite = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    id: json['id'] as int,
    title: json['title'] as String? ?? '',
    originalTitle: json['original_title'] as String? ?? '',
    overview: json['overview'] as String? ?? '',
    posterPath: json['poster_path'] as String?,
    backdropPath: json['backdrop_path'] as String?,
    releaseDate: json['release_date'] as String? ?? '',
    voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    voteCount: json['vote_count'] as int? ?? 0,
    runtime: json['runtime'] as int?,
    genreIds: (json['genre_ids'] as List<dynamic>?)
        ?.map((e) => e as int)
        .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'original_title': originalTitle,
    'overview': overview,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'release_date': releaseDate,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    'runtime': runtime,
    'genre_ids': genreIds,
  };

  Movie copyWith({bool? isFavorite}) => Movie(
    id: id,
    title: title,
    originalTitle: originalTitle,
    overview: overview,
    posterPath: posterPath,
    backdropPath: backdropPath,
    releaseDate: releaseDate,
    voteAverage: voteAverage,
    voteCount: voteCount,
    runtime: runtime,
    genreIds: genreIds,
    isFavorite: isFavorite ?? this.isFavorite,
  );

  String get year => releaseDate.length >= 4 ? releaseDate.substring(0, 4) : '';
  String get ratingFormatted => voteAverage.toStringAsFixed(1);
  String get durationFormatted {
    if (runtime == null) return '';
    final h = runtime! ~/ 60;
    final m = runtime! % 60;
    return h > 0 ? '${h}h ${m}min' : '${m}min';
  }
}