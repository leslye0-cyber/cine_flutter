class Actor {
  final int id;
  final String name;
  final String character;
  final String? profilePath;
  final int order;

  const Actor({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
    required this.order,
  });

  factory Actor.fromJson(Map<String, dynamic> json) => Actor(
    id: json['id'] as int,
    name: json['name'] as String? ?? '',
    character: json['character'] as String? ?? '',
    profilePath: json['profile_path'] as String?,
    order: json['order'] as int? ?? 0,
  );
}