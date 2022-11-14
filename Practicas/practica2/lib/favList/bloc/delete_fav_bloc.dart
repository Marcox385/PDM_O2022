import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'delete_fav_event.dart';
part 'delete_fav_state.dart';

class DeleteFavBloc extends Bloc<DeleteFavEvent, DeleteFavState> {
  DeleteFavBloc() : super(DeleteFavInitial()) {
    on<DeleteRequestedEvent>(_updateList);
    on<FavListEnterEvent>(_showScreen);
  }

  Future _updateList(DeleteRequestedEvent event, emit) async {
    emit(DeleteRequestedState());
    CollectionReference users =
        FirebaseFirestore.instance.collection('find_track_app');

    await users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'fav_list.${event.song_id}': FieldValue.delete()});

    dynamic favList = await _getFavorites();
    emit(UpdatedListState(favList: favList));
  }

  Future _showScreen(FavListEnterEvent event, emit) async {
    dynamic favList = await _getFavorites();
    emit(LoadedListState(favList: favList));
  }

  Future<List> _getFavorites() async {
    List favList = await [];
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('find_track_app');

      await users
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          var songs = doc['fav_list']!;
          var songs_ids = songs.keys;

          songs_ids.forEach((i) {
            favList.add({
              'song_id': i,
              'img_url': songs[i]['img_url'],
              'song_title': songs[i]['song_title'],
              'artist': songs[i]['artist'],
              'song_url': songs[i]['song_url']
            });
          });
        });
      });

      return favList;
    } catch (e) {
      print('Exception occured: $e');
    } finally {
      return favList;
    }
  }
}
