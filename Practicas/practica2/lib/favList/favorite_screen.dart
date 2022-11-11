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
          String albumImg = FavList.favList[index]['albumImg'];
          String songTitle = FavList.favList[index]['songTitle'];
          String artistName = FavList.favList[index]['artistName'];
          String linkList = FavList.favList[index]['linkList'];

          return FavItem(
              albumImg: albumImg,
              songTitle: songTitle,
              artistName: artistName,
              linkList: linkList);
        },
      ),
    );
  }
}