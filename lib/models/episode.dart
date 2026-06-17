class Episode {
  final int showId;
  final String name;
  final int season;
  final int number;
  final String? airdate;
  final String? runtime;
  final String? summary;
  final String? image;

  Episode({
    required this.showId,
    required this.name,
    required this.season,
    required this.number,
    this.airdate,
    this.runtime,
    this.summary,
    this.image,
  });

  factory Episode.fromJson(Map<String, dynamic> json, int showId) {
    return Episode(
      showId: showId,
      name: json['name'],
      season: json['season'],
      number: json['number'],
      airdate: json['airdate'],
      runtime: json['runtime']?.toString(),
      summary: json['summary'],
      image: json['image']?['medium'],
    );
  }
}