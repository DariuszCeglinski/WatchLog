import 'package:hive_ce/hive.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  Box get userBox => Hive.box('user');

  List<int> get favorites => List<int>.from(userBox.get('favorites', defaultValue: []));
  List<int> get watchlist => List<int>.from(userBox.get('watchlist', defaultValue: []));
  List<int> get ignored => List<int>.from(userBox.get('ignored', defaultValue: []));
  List<int> get watched => List<int>.from(userBox.get('watched', defaultValue: []));

  Future<void> addFavorite(int id) async {
    final list = favorites;

    if (!list.contains(id)) {
      list.add(id);
      await userBox.put('favorites', list);
    }
  }

  Future<void> removeFavorite(int id) async {
    final list = favorites;
    list.remove(id);

    await userBox.put('favorites', list);
  }

  Future<void> addToWatchlist(int id) async {
    final list = watchlist;

    if (!list.contains(id)) {
      list.add(id);
      await userBox.put('watchlist', list);
    }
  }

  Future<void> removeFromWatchlist(int id) async {
    final list = watchlist;

    list.remove(id);
    await userBox.put('watchlist', list);
  }

  Future<void> addIgnored(int id) async {
    final list = ignored;

    if (!list.contains(id)) {
      list.add(id);
      await userBox.put('ignored', list);
    }
  }

  Future<void> removeIgnored(int id) async {
    final list = ignored;
    list.remove(id);

    await userBox.put('ignored', list);
  }

  Future<void> addWatched(int id) async {
    final list = watched;

    if (!list.contains(id)) {
      list.add(id);
      await userBox.put('watched', list);
    }
  }

  Future<void> removeWatched(int id) async {
    final list = watched;
    list.remove(id);

    await userBox.put('watched', list);
  }

  Future<void> saveReview(int id, int rating, String note) async {
    final data = reviews;
    data[id.toString()] = { "rating": rating, "note": note };

    await userBox.put('reviews', data);
  }

  Future<void> removeReview(int id) async {
    final data = reviews;
    data.remove(id.toString());

    await userBox.put('reviews', data);
  }

  Map<String, dynamic>? getReview(int id){
    final data = reviews;
    final review = data[id.toString()];

    if (review == null) {
      return null;
    }

    return Map<String, dynamic>.from(review);
  }

  Map<String, dynamic> get reviews => Map<String, dynamic>.from(
    userBox.get('reviews', defaultValue: {}),
  );

  Set<int> get hiddenShows => {...favorites, ...watchlist, ...ignored, ...watched };

  bool isViewed(int id) {
    return watched.contains(id);
  }

  bool isFavorite(int id) {
    return favorites.contains(id);
  }

  bool isWatchlist(int id) {
    return watchlist.contains(id);
  }

  bool isIgnored(int id) {
    return ignored.contains(id);
  }
}