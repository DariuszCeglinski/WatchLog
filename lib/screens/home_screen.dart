import 'package:flutter/material.dart';
import 'package:watchlog/models/show.dart';
import 'package:watchlog/services/tvmaze_service.dart';

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
                              return _ShowCard(show: shows[index]);
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
                                return _ShowCard(show: shows[index]);
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

class _ShowCard extends StatelessWidget {
  final Show show;
  const _ShowCard({super.key, required this.show,});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 252,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xffd8d0d5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: show.image != null ? Image.network(show.image!, width: 80, height: 120, fit: BoxFit.cover) : Container(
              width: 80,
              height: 125,
              color: Colors.grey.shade400,
              child: const Icon(Icons.movie),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  show.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  show.genres.take(2).join(", "),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                  ),
                ),
                if (show.airtime != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sezon ${show.season}",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "Odc. ${show.episode}",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "godzina ${show.airtime}",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  )
                else if (show.seasons != null && show.episodes != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${show.seasons} sezonów",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "${show.episodes} odcinków",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                const Spacer(),
                Row(
                  children: [
                    if (show.rating != null) ...[
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${show.rating}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    const Spacer(),
                    InkWell(
                      onTap: () {},
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {},
                      child: const Icon(
                        Icons.bookmark_add,
                        color: Colors.blue,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}