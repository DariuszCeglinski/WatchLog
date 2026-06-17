import 'package:flutter/material.dart';
import 'package:watchlog/models/show.dart';
import 'package:watchlog/services/tvmaze_service.dart';
import 'package:watchlog/widgets/show_card.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TVMazeService _service = TVMazeService.instance;
  final TextEditingController _searchController = TextEditingController();
  late Future<void> _initializeFuture;

  Future<List<Show>>? _searchFuture;

  @override
  void initState() {
    super.initState();
    _initializeFuture = _service.initialize();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchShows(String query) async {
    setState(() {
      if (query.trim().isEmpty) {
        _searchFuture = null;
      } else {
        _searchFuture = _service.searchLibraryShows(query);
      }
    });
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
              SearchBar(
                controller: _searchController,
                hintText: "Wyszukaj obejrzany serial",
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
                          _searchFuture = null;
                        });
                      },
                    )
                ],
              ),
              const SizedBox(height: 10),
              if (_searchFuture != null)
                Expanded(
                  child: FutureBuilder<List<Show>>(
                    future: _searchFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final shows = snapshot.data ?? [];

                      if (shows.isEmpty) {
                        return const Center(child: Text("Nie znaleziono seriali"),);
                      }

                      return ListView.separated(
                        itemCount: shows.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) => ShowCard(show: shows[index]),
                      );
                    },
                  ),
                )
              else
                Expanded(
                  child: ListView(
                    children: [
                      const Text(
                        "Obejrzane",
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
                                future: _service.getWatchedShows(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(child: CircularProgressIndicator());
                                  }

                                  final shows = snapshot.data!;

                                  if (shows.isEmpty) {
                                    return const Center(child: Text('Brak obejrzanych filmów'));
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
                        "Ulubione",
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
                                  future: _service.getFavoriteShows(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState != ConnectionState.done) {
                                      return const Center(child: CircularProgressIndicator());
                                    }

                                    final shows = snapshot.data!;

                                    if (shows.isEmpty) {
                                      return const Center(child: Text('Brak Ulubionych filmów'));
                                    }

                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: shows.length,
                                      itemBuilder: (context, index) {
                                        return ShowCard(show: shows[index], onChanged: refresh);
                                      },
                                    );
                                  }
                              );
                            }
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Ocenione",
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
                                  future: _service.getRatedShows(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState != ConnectionState.done) {
                                      return const Center(child: CircularProgressIndicator());
                                    }

                                    final shows = snapshot.data!;

                                    if (shows.isEmpty) {
                                      return const Center(child: Text('Brak Ocenionych filmów'));
                                    }

                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: shows.length,
                                      itemBuilder: (context, index) {
                                        return ShowCard(show: shows[index], onChanged: refresh);
                                      },
                                    );
                                  }
                              );
                            }
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Z notatką",
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
                                  future: _service.getNotedShows(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState != ConnectionState.done) {
                                      return const Center(child: CircularProgressIndicator());
                                    }

                                    final shows = snapshot.data!;

                                    if (shows.isEmpty) {
                                      return const Center(child: Text('Brak Filmów z notatką'));
                                    }

                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: shows.length,
                                      itemBuilder: (context, index) {
                                        return ShowCard(show: shows[index], onChanged: refresh);
                                      },
                                    );
                                  }
                              );
                            }
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Ignorowane",
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
                                  future: _service.getIgnoredShows(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState != ConnectionState.done) {
                                      return const Center(child: CircularProgressIndicator());
                                    }

                                    final shows = snapshot.data!;

                                    if (shows.isEmpty) {
                                      return const Center(child: Text('Brak Ignorowanych filmów'));
                                    }

                                    return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: shows.length,
                                      itemBuilder: (context, index) {
                                        return ShowCard(show: shows[index], onChanged: refresh);
                                      },
                                    );
                                  }
                              );
                            }
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        )
    );
  }
}