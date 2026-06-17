import 'package:flutter/material.dart';
import 'package:watchlog/services/database_service.dart';
import 'package:watchlog/services/tvmaze_service.dart';
import 'package:watchlog/models/show.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final database = DatabaseService.instance;
  final service = TVMazeService.instance;

  late Future<void> _initializeFuture;

  @override
  void initState() {
    super.initState();
    _initializeFuture = service.initialize();
  }

  double get averageRating {
    if(database.reviews.isEmpty){
      return 0;
    }

    final ratings = database.reviews.values.where((e)=> e['rating'] != null).map((e)=> e['rating'] as int).toList();
    if(ratings.isEmpty){
      return 0;
    }

    return ratings.reduce((a,b)=>a+b) / ratings.length;
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: FutureBuilder(
        future: _initializeFuture,
        builder:(context,snapshot){
          if(snapshot.connectionState != ConnectionState.done){
            return const Center(
              child:CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height:20),
                _stats(),
                const SizedBox(height:25),
                const Text(
                  "Najwyżej ocenione",
                  style:TextStyle(
                    fontSize:22,
                    fontWeight:FontWeight.bold,
                  ),
                ),
                const SizedBox(height:10),
                FutureBuilder(
                  future: service.getRatedShows(),
                  builder:(context,snapshot){
                    if(!snapshot.hasData){
                      return const CircularProgressIndicator();
                    }
                    final shows = snapshot.data!;
                    shows.sort((a,b)=> (b.rating??0).compareTo(a.rating??0));
                    return SizedBox(
                      height:180,
                      child:ListView.builder(
                        scrollDirection:Axis.horizontal,
                        itemCount:shows.take(5).length,
                        itemBuilder:(context,index){
                          return _ratingCard(shows[index]);
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height:25),
                _categoryCard(),
                const SizedBox(height:25),
                _reviewsCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _header(){
    return Container(
      width:double.infinity,
      padding:const EdgeInsets.all(20),
      decoration:BoxDecoration(
        borderRadius:BorderRadius.circular(22),
        gradient:const LinearGradient(
          colors:[
            Colors.black12,
            Colors.deepPurpleAccent
          ],
        ),
      ),
      child:Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children:[
          const Text(
            "Witaj Użytkowniku",
            style:TextStyle(
              fontSize:26,
              fontWeight:FontWeight.bold,
            ),
          ),
          Text(
            "Twój profil serialowy",
            style:TextStyle(
              fontStyle: FontStyle.italic,
              color:Colors.grey.shade700,
            ),
          )
        ],
      ),
    );
  }
  Widget _stats(){
    return Wrap(
      alignment: WrapAlignment.center,
      spacing:12,
      runSpacing:12,
      children:[
        _stat(
          "Obejrzane",
          database.watched.length,
          Icons.visibility,
        ),
        _stat(
          "Do obejrzenia",
          database.watchlist.length,
          Icons.bookmark,
        ),
        _stat(
          "Ulubione",
          database.favorites.length,
          Icons.favorite,
        ),
        _stat(
          "Oceny",
          database.reviews.length,
          Icons.star,
        ),
      ],
    );
  }
  Widget _stat(
      String text,
      int value,
      IconData icon
      ){
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 22,
      padding:const EdgeInsets.all(14),
      decoration:BoxDecoration(
        color:Colors.grey.shade200,
        borderRadius:BorderRadius.circular(18),
      ),
      child:Row(
        children:[
          Icon(icon),
          const SizedBox(width:10),
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children:[
              Text(
                "$value",
                style:const TextStyle(
                  fontSize:20,
                  fontWeight:FontWeight.bold,
                ),
              ),
              Text(text),
            ],
          )
        ],
      ),
    );
  }

  Widget _ratingCard(Show show){
    return Container(
      width:130,
      margin:const EdgeInsets.only(right:12),
      child:Column(
        children:[
          Expanded(
            child:ClipRRect(
              borderRadius:
              BorderRadius.circular(14),
              child: show.image != null? Image.network(
                show.image!,
                fit:BoxFit.cover,
              ) : const Icon(Icons.movie),
            ),
          ),
          const SizedBox(height:5),
          Text(
            show.name,
            maxLines:1,
            overflow:TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children:[
              const Icon(
                Icons.star,
                color:Colors.amber,
                size:16,
              ),
              Text(
                "${show.rating}",
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _categoryCard(){
    return FutureBuilder(
      future:service.getFavoriteGenre(),
      builder:(context,snapshot){
        return Card(
          child:ListTile(
            leading: const Icon(Icons.category),
            title: const Text("Najczęściej oglądana kategoria"),
            subtitle: Text( snapshot.data ?? "Brak danych"),
          ),
        );
      },
    );
  }

  Widget _reviewsCard(){
    return Card(
      child:Padding(
        padding:const EdgeInsets.all(16),
        child:Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children:[
            const Text(
              "Twoje statystyki",
              style:TextStyle(
                fontSize:20,
                fontWeight:FontWeight.bold,
              ),
            ),
            const SizedBox(height:10),
            Row(
              children: [
                Text("Średnia wystawiana ocena: ${averageRating.toStringAsFixed(1)}"),
                const SizedBox(width: 6),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 20,
                ),
              ],
            ),
            Text("Napisane opinie: ${database.reviews.length}",),
            Text("Ignorowane seriale: ${database.ignored.length}",),
          ],
        ),
      ),
    );
  }
}