class FavList {
  static Map<String, dynamic> favList = {};

  Map<String, dynamic> get favs => favList;

  static bool addSong(String id, dynamic values) {
    dynamic res = favList.putIfAbsent(id, () => values);

    return res == values; // True: item was already in list
  }

  static bool deleteSong(int id) {
    return favList.remove(id) ? true : false;
  }
}
