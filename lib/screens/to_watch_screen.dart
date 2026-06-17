import 'package:flutter/material.dart';
import 'package:watchlog/services/tvmaze_service.dart';
import 'package:watchlog/widgets/episode_card.dart';
import 'package:watchlog/widgets/show_card.dart';

class ToWatchScreen extends StatefulWidget {
  const ToWatchScreen({super.key});

  @override
  State<ToWatchScreen> createState() => _ToWatchScreen();
}

class _ToWatchScreen extends State<ToWatchScreen> {
  final TVMazeService _service = TVMazeService.instance;
  late Future<void> _initializeFuture;

  @override
  void initState() {
    super.initState();
    _initializeFuture = _service.initialize();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> refresh() async {
      setState(() {
        _initializeFuture = _service.initialize();
      });
    }

    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Seriale do obejrzenia",
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
                        future: _service.getWatchlistShows(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final shows = snapshot.data!;

                          if (shows.isEmpty) {
                            return const Center(child: Text('Brak seriali dodanych do obejrzenia'));
                          }

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: shows.length,
                            itemBuilder: (context, index) {
                              return ShowCard(show: shows[index], onChanged: refresh);
                            },
                          );
                        },
                      );
                    }
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Odcinki do obejrzenia",
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
                          future: _service.getWatchlistEpisodes(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState != ConnectionState.done) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            final episodes = snapshot.data!;

                            if (episodes.isEmpty) {
                              return const Center(child: Text('Brak odcinków dodanych do obejrzenia'));
                            }

                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: episodes.length,
                              itemBuilder: (context, index) {
                                return EpisodeCard(episode: episodes[index], onChanged: refresh);
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