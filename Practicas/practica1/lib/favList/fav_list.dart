class FavList {
  static Map<int, dynamic> favList = {
    0: {
      'albumImg': 'https://m.media-amazon.com/images/I/31wx3zcYTfL.jpg',
      'songTitle': 'Gorgeous',
      'artistName': 'Ye',
      'linkList': 'https://lis.tn/Warriors'
    }
  };

  Map<int, dynamic> get favs => favList;

  bool addSong(int id, dynamic values) {
    dynamic res = this.favs.putIfAbsent(id, () => values);

    return res == values; // True: item was already in list
  }

  bool deleteSong(int id) {
    return this.favs.remove(id) ? true : false;
  }
}
