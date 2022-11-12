import 'package:findtrackapp_v2/favList/components/fav_item.dart';
import 'package:findtrackapp_v2/favList/fav_list.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FavList favlist = FavList();
    favlist.getFavorites();

    return Scaffold(
      appBar: AppBar(title: Text('Canciones favoritas')),
      body: ListView.builder(
        // itemCount: FavList.favList.length,
        itemCount: favlist.getFavList.length,
        itemBuilder: (BuildContext context, int index) {
          dynamic curr_item = favlist.getFavList[index];

          return FavItem(
              song_id: curr_item['song_id'],
              img_url: curr_item['img_url'],
              song_title: curr_item['song_title'],
              artist: curr_item['artist'],
              song_url: curr_item['song_url']);
        },
      ),
    );
  }
}
