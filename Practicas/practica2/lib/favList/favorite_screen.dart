import 'package:findtrackapp_v2/favList/components/fav_item.dart';
import 'package:findtrackapp_v2/favList/fav_list.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Canciones favoritas')),
      body: ListView.builder(
        itemCount: FavList.favList.length,
        itemBuilder: (BuildContext context, int index) {
          String song_id = FavList.favList[index]['song_id'];
          String img_url = FavList.favList[index]['img_url'];
          String song_title = FavList.favList[index]['song_title'];
          String artist = FavList.favList[index]['artist'];
          String song_url = FavList.favList[index]['song_url'];

          print(FavList.favList);

          return FavItem(
              song_id: song_id,
              img_url: img_url,
              song_title: song_title,
              artist: artist,
              song_url: song_url);
        },
      ),
    );
  }
}
