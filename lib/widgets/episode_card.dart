import 'package:flutter/material.dart';
import 'package:watchlog/models/episode.dart';
import 'package:watchlog/services/database_service.dart';

class EpisodeCard extends StatefulWidget {
  final Episode episode;
  final VoidCallback? onChanged;

  const EpisodeCard({
    super.key,
    required this.episode,
    this.onChanged,
  });

  @override
  State<EpisodeCard> createState() => _EpisodeCardState();
}

class _EpisodeCardState extends State<EpisodeCard> {
  final database = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    final episode = widget.episode;
    final status = database.getEpisodeStatus(episode.showId, episode.number);

    return Container(
      width: 252,
      height: 140,
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
            child: episode.image != null ? Image.network(
              episode.image!,
              width: 80,
              height: 120,
              fit: BoxFit.cover,
            ) : Container(
              width: 80,
              height: 120,
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
                  episode.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "Sez. ${episode.season} |",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      " Odc. ${episode.number}",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                if (episode.runtime != null)
                  Text(
                    "${episode.runtime} min",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                    ),
                  ),
                const Spacer(),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        await database.setEpisodeStatus(
                          episode.showId,
                          episode.number,
                          status == "watched" ? "none" : "watched",
                        );
                        setState(() {
                          widget.onChanged?.call();
                        });
                      },
                      child: Icon(
                        status == "watched" ? Icons.check_circle : Icons.check_circle_outline,
                        color: status == "watched" ? Colors.green : Colors.grey,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () async {
                        await database.setEpisodeStatus(
                          episode.showId,
                          episode.number,
                          status == "watchlist" ? "none" : "watchlist",
                        );
                        setState(() {
                          widget.onChanged?.call();
                        });
                      },
                      child: Icon(
                        status == "watchlist" ? Icons.bookmark : Icons.bookmark_border,
                        color: status == "watchlist" ? Colors.blue : Colors.grey,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}