import 'package:hive_ce/hive.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  Box get userBox => Hive.box('user');

  List<int> get favorites => List<int>.from(userBox.get('favorites', defaultValue: []));

  List<int> get watchlist => List<int>.from(userBox.get('watchlist', defaultValue: []));

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

  bool isFavorite(int id) {
    return favorites.contains(id);
  }

  bool isWatchlist(int id) {
    return watchlist.contains(id);
  }
}