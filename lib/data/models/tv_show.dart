class TvShow {
  final int id;
  final String name;
  final String originalName;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String firstAirDate;
  final double voteAverage;
  final int voteCount;
  final List<int> genreIds;
  bool isFavorite;

  TvShow({
    required this.id,
    required this.name,
    required this.originalName,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
    this.isFavorite = false,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) => TvShow(
    id: json['id'] as int,
    name: json['name'] as String? ?? '',
    originalName: json['original_name'] as String? ?? '',
    overview: json['overview'] as String? ?? '',
    posterPath: json['poster_path'] as String?,
    backdropPath: json['backdrop_path'] as String?,
    firstAirDate: json['first_air_date'] as String? ?? '',
    voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    voteCount: json['vote_count'] as int? ?? 0,
    genreIds: (json['genre_ids'] as List<dynamic>?)
        ?.map((e) => e as int)
        .toList() ??
        [],
  );

  String get year =>
      firstAirDate.length >= 4 ? firstAirDate.substring(0, 4) : '';
  String get ratingFormatted => voteAverage.toStringAsFixed(1);
}