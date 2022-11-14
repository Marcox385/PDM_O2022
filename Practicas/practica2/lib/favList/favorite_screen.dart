import 'package:findtrackapp_v2/favList/bloc/delete_fav_bloc.dart';
import 'package:findtrackapp_v2/favList/components/fav_item.dart';
import 'package:findtrackapp_v2/favList/fav_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Canciones favoritas')),
        body: BlocConsumer<DeleteFavBloc, DeleteFavState>(
            listener: (context, state) {
          if (state is DeleteRequestedEvent) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Procesando...')));
          } else if (state is UpdatedListState) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Eliminado exitósamente...')));
          }
        }, builder: ((context, state) {
          if (state is DeleteFavInitial) {
            FavList aid = FavList();
            return FutureBuilder(
                future: aid.getFavorites(),
                builder: ((context, data) {
                  if (!data.hasData)
                    return Center(child: CircularProgressIndicator());

                  var favList = data.data as List;

                  return ListView.builder(
                      itemCount: favList.length,
                      itemBuilder: (BuildContext context, int index) {
                        dynamic curr_item = favList[index];

                        return FavItem(
                            song_id: curr_item['song_id'],
                            img_url: curr_item['img_url'],
                            song_title: curr_item['song_title'],
                            artist: curr_item['artist'],
                            song_url: curr_item['song_url']);
                      });
                }));
          } else if (state is UpdatedListState) {
            return ListView.builder(
                itemCount: state.favList.length,
                itemBuilder: (BuildContext context, int index) {
                  dynamic curr_item = state.favList[index];

                  return FavItem(
                      song_id: curr_item['song_id'],
                      img_url: curr_item['img_url'],
                      song_title: curr_item['song_title'],
                      artist: curr_item['artist'],
                      song_url: curr_item['song_url']);
                });
          } else if (state is LoadedListState) {
            return ListView.builder(
                itemCount: state.favList.length,
                itemBuilder: (BuildContext context, int index) {
                  dynamic curr_item = state.favList[index];

                  return FavItem(
                      song_id: curr_item['song_id'],
                      img_url: curr_item['img_url'],
                      song_title: curr_item['song_title'],
                      artist: curr_item['artist'],
                      song_url: curr_item['song_url']);
                });
          } else if (state is DeleteRequestedState) {
            return Center(child: CircularProgressIndicator());
          }

          return Text('Error retrieving list');
        })));
  }
}
