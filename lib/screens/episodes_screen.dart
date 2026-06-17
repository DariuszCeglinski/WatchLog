import 'package:flutter/material.dart';
import 'package:watchlog/models/episode.dart';
import 'package:watchlog/services/database_service.dart';
import 'package:watchlog/services/tvmaze_service.dart';

class EpisodesScreen extends StatefulWidget {
  final int showId;

  const EpisodesScreen ({ super.key, required this.showId});

  @override
  State<StatefulWidget> createState() => _EpisodesScreen();
}

class _EpisodesScreen extends State<EpisodesScreen> {
  final TVMazeService _service = TVMazeService.instance;
  final database = DatabaseService.instance;

  String removeHtml(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Odcinki"),
      ),
      body: FutureBuilder<List<Episode>>(
        future: _service.getEpisodes(widget.showId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(),);
          }
          final episodes = snapshot.data!;
          final Map<int, List<Episode>> seasons = {};

          for (final ep in episodes) {
            seasons.putIfAbsent(ep.season, () => []);
            seasons[ep.season]!.add(ep);
          }
          return ListView(
            children: seasons.entries.map((entry) {
              return ExpansionTile(
                title: Text("Sezon ${entry.key}"),
                children: entry.value.map((episode) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: episode.image != null ? Image.network(
                              episode.image!,
                              width: 100,
                              height: 140,
                              fit: BoxFit.cover,
                            ) : Container(
                              width: 100,
                              height: 140,
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.movie,
                                size: 40,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  episode.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Odcinek ${episode.number}",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                const SizedBox(height: 8),
                                if (episode.airdate != null)
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 16),
                                      const SizedBox(width: 6),
                                      Text(episode.airdate!),
                                    ],
                                  ),
                                const SizedBox(height: 6),
                                if (episode.runtime != null)
                                  Row(
                                    children: [
                                      const Icon(Icons.schedule, size: 16),
                                      const SizedBox(width: 6),
                                      Text("${episode.runtime} min"),
                                    ],
                                  ),
                                if (episode.summary != null) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    removeHtml(episode.summary!),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: database.getEpisodeStatus(widget.showId, episode.number) == "watched" ? Colors.green : Colors.grey,
                                      ),
                                      onPressed: () async {
                                        final current = database.getEpisodeStatus(
                                          widget.showId,
                                          episode.number,
                                        );

                                        await database.setEpisodeStatus(widget.showId, episode.number, current == "watched" ? "none" : "watched",);

                                        setState(() {});
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.bookmark,
                                        color: database.getEpisodeStatus(widget.showId, episode.number) == "watchlist" ? Colors.blue : Colors.grey,
                                      ),
                                      onPressed: () async {
                                        final current = database.getEpisodeStatus(widget.showId, episode.number);

                                        await database.setEpisodeStatus(
                                          widget.showId,
                                          episode.number,
                                          current == "watchlist" ? "none" : "watchlist",
                                        );

                                        setState(() {});
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}