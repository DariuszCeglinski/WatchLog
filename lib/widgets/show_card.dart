import 'package:flutter/material.dart';
import 'package:watchlog/models/show.dart';
import 'package:watchlog/screens/details_screen.dart';
import 'package:watchlog/services/database_service.dart';

class ShowCard extends StatefulWidget{
  final Show show;
  final VoidCallback? onChanged;

  const ShowCard({ super.key, required this.show, this.onChanged});

  @override
  State<StatefulWidget> createState() => _ShowCard();
}

class _ShowCard extends State<ShowCard> {
  final database = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    final show = widget.show;
    final isFavorite = database.isFavorite(show.id);
    final isWatchlist = database.isWatchlist(show.id);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailsScreen(show: show),
          )
        ).then((_) {
          setState(() {});
          widget.onChanged?.call();
        });
      },
      child: Container(
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                    const Spacer(),
                    InkWell(
                      onTap: () async {
                        if (isFavorite) {
                          await database.removeFavorite(show.id);
                        } else {
                          await database.addFavorite(show.id);
                        }

                        setState(() {});
                        widget.onChanged?.call();
                      },
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () async {
                        if (isWatchlist) {
                          await database.removeFromWatchlist(show.id);
                        } else {
                          await database.addToWatchlist(show.id);
                        }

                        setState(() {});
                        widget.onChanged?.call();
                      },
                      child: Icon(
                        isWatchlist ? Icons.bookmark : Icons.bookmark_border,
                        color: isWatchlist ? Colors.blue : Colors.grey,
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
    ),
    );
  }
}