import 'package:flutter/material.dart';
import 'package:watchlog/models/show.dart';
import 'package:watchlog/screens/episodes_screen.dart';
import 'package:watchlog/services/database_service.dart';

class DetailsScreen extends StatefulWidget {
  final Show show;

  const DetailsScreen({ super.key, required this.show });

  @override
  State<StatefulWidget> createState() => _DetailsScreen();
}

class _DetailsScreen extends State<DetailsScreen> {
  final database = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    final show = widget.show;

    final review = database.getReview(show.id);
    final bool wasViewed = database.isViewed(show.id);
    final bool isFavorite = database.isFavorite(show.id);
    final bool isWatchlist = database.isWatchlist(show.id);
    final bool isIgnored = database.isIgnored(show.id);

    int myRating = 0;
    String myNote = "";

    if (review != null) {
      myRating = review['rating'] ?? 0;
      myNote = review['note'] ?? '';
    }

    String removeHtmlTags(String html) {
      return html.replaceAll(RegExp(r'<[^>]*>'), '');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(show.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: show.image != null ? Image.network(
                    show.image!,
                    width: 150,
                    height: 220,
                    fit: BoxFit.cover,
                  ) : Container(
                    width: 150,
                    height: 220,
                    color: Colors.grey,
                    child: const Icon(Icons.movie),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Status: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(show.status ?? "Brak danych")
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            "Śr. Ocen: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("${show.rating ?? '-'}"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Kategorie:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        show.genres.join(", "),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      if (show.seasons != null)
                        Text(
                          "Sezony: ${show.seasons}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (show.episodes != null)
                        Text(
                          "Liczba odcinków: ${show.episodes}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    if (isFavorite) {
                      await database.removeFavorite(show.id);
                    } else {
                      await database.addFavorite(show.id);
                    }

                    setState(() {});
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (isWatchlist) {
                      await database.removeFromWatchlist(show.id);
                    } else {
                      await database.addToWatchlist(show.id);
                    }

                    setState(() {});
                  },
                  icon: Icon(
                    isWatchlist ? Icons.bookmark : Icons.bookmark_border,
                    color: isWatchlist ? Colors.blue : Colors.grey,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (isIgnored) {
                      await database.removeIgnored(show.id);
                    } else {
                      await database.addIgnored(show.id);
                    }

                    setState(() {});
                  },
                  icon: Icon(
                    isIgnored ? Icons.block : Icons.block_outlined,
                    color: isIgnored ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Twoja ocena:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                ...List.generate(10, (index) => Icon(
                    index < myRating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Opis",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              removeHtmlTags(show.summary ?? "Brak opisu") ,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EpisodesScreen(showId: show.id)
                      )
                    ).then((_) {
                      setState(() {});
                    });
                  },
                  child: const Text("Zobacz odcinki"),
                ),
                const SizedBox(width: 20),
                FilledButton(
                  onPressed: () {
                    int dialogRating = myRating;
                    showDialog(
                      context: context,
                      builder: (context) {
                        final controller = TextEditingController(
                          text: myNote,
                        );

                        return AlertDialog(
                          title: const Text("Twoja opinia"),
                          content: StatefulBuilder(
                            builder: (context, dialogSetState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Wrap(
                                    children: List.generate(10, (index) {
                                      final star = index + 1;

                                      return IconButton(
                                        onPressed: () {
                                          dialogSetState(() {
                                            dialogRating = star;
                                          });
                                        },
                                        icon: Icon(
                                          star <= dialogRating ? Icons.star : Icons.star_border,
                                          color: Colors.amber,
                                        ),
                                      );
                                    }),
                                  ),
                                  Text(
                                    "$dialogRating / 10",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: controller,
                                    maxLines: 5,
                                    maxLength: 500,
                                    decoration: const InputDecoration(
                                      hintText: "Dodaj komentarz",
                                      border: OutlineInputBorder()
                                    ),
                                  ),
                                ],
                              );
                            }
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Anuluj"),
                            ),
                            FilledButton(
                                onPressed: () async {
                                  await database.saveReview(show.id, dialogRating, controller.text);
                                  if (!mounted) return;

                                  setState(() {
                                    myRating = dialogRating;
                                    myNote = controller.text;
                                  });

                                  Navigator.pop(context);
                                },
                                child: const Text("Zapisz"),
                            ),
                          ],
                        );
                      }
                    );
                  },
                  child: Text(myNote.isEmpty ? "Dodaj opinię" : "Zobacz opinię"),
                ),
              ],
            ),
            FilledButton(
              onPressed: () async {
                if (wasViewed) {
                  database.removeWatched(show.id);
                } else {
                  database.addWatched(show.id);
                }
                setState(() {});
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  wasViewed ? Colors.grey : Colors.lightGreen
                )
              ),
              child: Text(wasViewed ? "Obejrzane - cofnij status" : "Oznacz jako obejrzane")
            ),
          ],
        ),
      ),
    );
  }
}