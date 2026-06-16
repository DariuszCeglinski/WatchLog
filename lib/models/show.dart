class Show {
  final int id;
  final String name;
  final String? image;
  final String? summary;
  final String? type;
  final double? rating;
  final List<dynamic> genres;
  final int? weight;

  final int? seasons;
  final int? episodes;

  final String? airtime;
  final int? season;
  final int? episode;

  Show({
    required this.id,
    required this.name,
    this.image,
    this.type,
    this.summary,
    this.rating,
    required this.genres,
    this.weight,
    this.seasons,
    this.episodes,
    this.airtime,
    this.season,
    this.episode,
  });

  Show copyWith({
    int? seasons,
    int? episodes,
    final String? airtime,
    final int? season,
    final int? episode,
  }) {
    return Show(
      id: id,
      name: name,
      type: type,
      image: image,
      summary: summary,
      rating: rating,
      genres: genres,
      weight: weight,
      seasons: seasons ?? this.seasons,
      episodes: episodes ?? this.episodes,
      airtime: airtime ?? this.airtime,
      season: season ?? this.season,
      episode: episode ?? this.episode,
    );
  }

  factory Show.extractJson(Map<String, dynamic> json) {
    return Show(
      id: json['id'],
      name: json['name'],
      image: json['image']?['medium'],
      type: json['type'],
      summary: json['summary'],
      rating: json['rating']?['average']?.toDouble(),
      genres: json['genres'] ?? [],
      weight: json['weight'] ?? 0,
    );
  }
}