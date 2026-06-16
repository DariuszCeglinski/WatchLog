import 'package:flutter/material.dart';
import 'package:watchlog/screens/main_screen.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('user');

  final box = Hive.box('user');

  if (!box.containsKey('favorites')) {
    await box.put('favorites', <int>[]);
  }

  if (!box.containsKey('watchlist')) {
    await box.put('watchlist', <int>[]);
  }

  if (!box.containsKey('ignoredGenres')) {
    await box.put('ignoredGenres', <String>[]);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WatchLog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainScreen(),
    );
  }
}
