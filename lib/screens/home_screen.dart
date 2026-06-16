import 'package:flutter/material.dart';
import 'package:watchlog/services/tvmaze_service.dart';
import 'package:watchlog/widgets/show_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TVMazeService _service = TVMazeService.instance;
  late Future<void> _initializeFuture;

  @override
  void initState() {
    super.initState();
    _initializeFuture = _service.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBar(
                hintText: "Wyszukaj serial",
                leading: const Icon(Icons.search),
                elevation: const WidgetStatePropertyAll(0),
              ),
              const SizedBox(height: 10),
              const Text(
                "Obejrz dzisiaj",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 160,
                child: FutureBuilder(
                    future: _initializeFuture,
                    builder: (context, initSnapshot) {
                      if (initSnapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return FutureBuilder(
                        future: _service.getShowsToday(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final shows = snapshot.data!;

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: shows.length,
                            itemBuilder: (context, index) {
                              return ShowCard(show: shows[index]);
                            },
                          );
                        },
                      );
                    }
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Popularne",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 140,
                child: FutureBuilder(
                    future: _initializeFuture,
                    builder: (context, initSnapshot) {
                      if (initSnapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return FutureBuilder(
                          future: _service.getPopularShows(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState != ConnectionState.done) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            final shows = snapshot.data!;

                            if (shows.isEmpty) {
                              return const Center(child: Text('Brak danych'));
                            }

                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: shows.length,
                              itemBuilder: (context, index) {
                                return ShowCard(show: shows[index]);
                              },
                            );
                          }
                      );
                    }
                ),
              )
            ],
          ),
        )
    );
  }
}