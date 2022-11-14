import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavList {
  static List<Map> favList = [];

  // List<Map> get getFavList => favList;

  /**
   * Populate favorite list for visual displaying
   */
  Future<List> getFavorites() async {
    try {
      favList = await [];

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
      FavList.favList = await favList;
      return favList;
    } catch (e) {
      print('Exception occured: $e');
    } finally {
      return favList;
    }
  }

  /**
   * Check song existance in user's favorites
   * Utility for message displaying
   * True = song exists on favorites list
   */
  static Future<bool> _checkExistance(String song_id) async {
    bool exists = false;

    CollectionReference users =
        FirebaseFirestore.instance.collection('find_track_app');

    await users
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var fav_list = doc["fav_list"];

        if (fav_list.length == 0)
          return; // There´s no favorites (yet)
        else if (fav_list[song_id] != null) {
          exists = true; // Favorite exists within user list
          return;
        }
      });
    });

    return exists;
  }

  /**
   * Try to add song to user's favorites
   * Return value according operation result
   */
  static Future<bool> addToFavorites(String song_id, Map<String, String> song_values) async {
    if (await _checkExistance(song_id) == true) return false;

    await FirebaseFirestore.instance
        .collection('find_track_app')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'fav_list.$song_id': song_values});

    return true;
  }

  Future<void> deleteFromFavorites(String song_id) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('find_track_app');

    await users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'fav_list.$song_id': FieldValue.delete()});

    for (var i = 0; i < favList.length; i++) {
      if (favList[i]['song_id'] == song_id) {
        await favList.removeAt(i);
        return;
      }
    }
  }
}
