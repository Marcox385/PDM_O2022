// import 'package:FindTrackApp/favList/components/fav_item.dart';
import 'package:FindTrackApp/favList/fav_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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

          // return FavItem(
          //     albumImg: 'https://m.media-amazon.com/images/I/31wx3zcYTfL.jpg',
          //     songTitle: 'Prrr',
          //     artistName: 'Oasg',
          //     linkList: 'https://lis.tn/Warriors');
        },
      ),
    );
  }
}

class FavItem extends StatelessWidget {
  final String albumImg, songTitle, artistName, linkList;

  FavItem({
    super.key,
    required this.albumImg,
    required this.songTitle,
    required this.artistName,
    required this.linkList
  });

  Future<void> _launchUrl(String rawUrl) async {
    Uri _url = Uri.parse(rawUrl);

    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw 'Unable to launch URL';
    }
  }

  Future<void> _alertDialog(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: Text('Abrir canción'),
                content: Text(
                    'Será redirigido a ver opciones para abrir la canción ¿Quieres continuar?'),
                actions: <Widget>[
                  TextButton(
                      child: Text('Cancelar'),
                      onPressed: () => Navigator.pop(context, 'Cancelar')),
                  TextButton(
                      child: Text('Continuar'),
                      onPressed: () {
                        _launchUrl('$this.linkList');
                        Navigator.pop(context);
                      })
                ]));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Positioned(
                child: GestureDetector(
              child: Image.network(
                  '$this.albumImg'),
              onTap: () => {_alertDialog(context)},
            )),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.95),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5))),
                  child: Column(
                    children: [
                      Text(
                        "$this.songTitle",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "$this.artistName",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                onTap: () => {_alertDialog(context)},
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: IconButton(
                  icon: Icon(FontAwesomeIcons.solidHeart), onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
