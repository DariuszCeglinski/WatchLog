import 'package:flutter/material.dart';
import 'package:watchlog/models/show.dart';
import 'package:watchlog/services/tvmaze_service.dart';
import 'package:watchlog/widgets/show_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TVMazeService _service = TVMazeService.instance;
  final TextEditingController _searchController = TextEditingController();
  late Future<void> _initializeFuture;

  List<Show> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initializeFuture = _service.initialize();

    _searchController.addListener(() {
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchShows(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });

      return;
    }

    final results = await _service.searchShows(query);

    setState(() {
      _isSearching = true;
      _searchResults = results;
    });
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
                controller: _searchController,
                hintText: "Wyszukaj serial",
                leading: const Icon(Icons.search),
                elevation: const WidgetStatePropertyAll(0),
                onChanged: _searchShows,
                trailing: [
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();

                        setState(() {
                          _isSearching = false;
                          _searchResults = [];
                        });
                      },
                    )
                ],
              ),
              const SizedBox(height: 10),
              if (_isSearching)
                Expanded(
                  child: ListView.separated(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      return ShowCard(show: _searchResults[index]);
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                ))
              else
                Expanded(
                  child: ListView(
                    children: [
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

                                  if (shows.isEmpty) {
                                    return const Center(child: Text('Brak odcinków wychodzących dzisiaj'));
                                  }

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
            ],
          ),
        )
    );
  }
}