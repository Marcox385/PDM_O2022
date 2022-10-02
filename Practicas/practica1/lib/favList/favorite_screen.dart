import 'package:FindTrackApp/favList/components/fav_item.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Canciones favoritas')),
      body: ListView(
        children: [FavItem(), FavItem(), FavItem()],
      ),
    );
  }
}
