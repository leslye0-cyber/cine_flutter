import 'package:hive/hive.dart';

part 'genre.g.dart';

@HiveType(typeId: 1)
class Genre {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  const Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
    id: json['id'] as int,
    name: json['name'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}