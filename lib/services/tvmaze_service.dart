import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:watchlog/models/show.dart';

class TVMazeService {
  final List<Show> _shows = [];
  static final TVMazeService instance = TVMazeService._internal();
  TVMazeService._internal();
  factory TVMazeService() => instance;

  int limit = 20;

  Future<void> initialize() async {
    if (_shows.isNotEmpty) return;

    final futures = List.generate(8, (page) async {
      final response = await http.get(Uri.parse('https://api.tvmaze.com/shows?page=$page'));

      if (response.statusCode != 200) return <Show>[];

      final List<dynamic> data = jsonDecode(response.body);

      return data.map<Show>((jsondata) => Show.extractJson(jsondata)).toList();});

    final results = await Future.wait<List<Show>>(futures);
    _shows.addAll(results.expand((show) => show));
  }

  Future<List<Show>> getPopularShows() async {
    final sorted = List<Show>.from(_shows);

    sorted.sort((a, b) {
      final weightCompare = (b.weight ?? 0).compareTo(a.weight ?? 0);
      if (weightCompare != 0) return weightCompare;

      return (b.rating ?? 0).compareTo(a.rating ?? 0);
    });

    final selectedShows = sorted.take(limit).toList();
    final result = <Show>[];

    for (final show in selectedShows) {
      result.add(await addShowInfo(show));
    }

    return result;
  }

  Future<List<Show>> getShowsToday() async {
    final today = DateTime.now().toIso8601String().split('T').first;
    final response = await http.get(Uri.parse('https://api.tvmaze.com/schedule?date=$today'));

    if (response.statusCode != 200) {
      return [];
    }

    final List<dynamic> data = jsonDecode(response.body);
    const allowedTypes = {
      'Scripted',
      'Animation',
      'Documentary',
      'Reality',
    };

    final shows = data.map((item) {
      return Show.extractJson(item['show']).copyWith(
        airtime: item['airtime'],
        season: item['season'],
        episode: item['number'],
      );
    }).where((show) => allowedTypes.contains(show.type)).toList();

    final uniqueShows = <int, Show>{
      for (final show in shows) show.id: show,
    };

    final selectedShows = uniqueShows.values.take(limit).toList();
    final result = <Show>[];

    for (final show in selectedShows) {
      result.add(await addShowInfo(show));
    }

    return result;
  }

  List<Show> getShowsByGenre(String genre) {
    return _shows.where((show) => show.genres.any((g) => g.toLowerCase() == genre.toLowerCase(),))
      .take(limit).toList();
  }

  Future<Show> addShowInfo(Show show) async {
    try {
      final response = await http.get(Uri.parse('https://api.tvmaze.com/shows/${show.id}/episodes'));

      if (response.statusCode != 200) return show;
      final List<dynamic> episodes = jsonDecode(response.body);

      if (episodes.isEmpty) return show;
      final seasonCount = episodes.map((e) => e['season'] as int).toSet().length;

      return show.copyWith(seasons: seasonCount, episodes: episodes.length,);
    } catch (e) {
      print(e);
      return show;
    }
  }
}