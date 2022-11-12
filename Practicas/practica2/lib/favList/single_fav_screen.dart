import 'package:findtrackapp_v2/favList/fav_list.dart';
import 'package:findtrackapp_v2/identify/identify_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleFavScreen extends StatelessWidget {
  final double imgSize = 370, iconSize = 50;

  dynamic albumImg;
  final dynamic song_id;
  final String songTitle,
      albumTitle,
      artistName,
      publishDate,
      linkSpotify,
      linkList,
      linkApple;

  SingleFavScreen(
      {super.key,
      required this.song_id,
      required this.songTitle,
      required this.albumTitle,
      required this.artistName,
      required this.publishDate,
      required this.linkSpotify,
      required this.linkList,
      required this.linkApple,
      required this.albumImg});

  Future<void> _launchUrl(String rawUrl) async {
    Uri _url = Uri.parse(rawUrl);

    if (!await launchUrl(_url)) {
      throw 'Unable to launch URL';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (albumImg == "")
      albumImg =
          'https://images.squarespace-cdn.com/content/v1/5d2e2c5ef24531000113c2a4/1564770295807-EJFN4EE3T23YXLMJMVJ5/image-asset.png?format=1000w';

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => IdentifyScreen()));
            },
          ),
          title: Text('Here you go'),
          actions: [
            IconButton(
              icon: Icon(FontAwesomeIcons.solidHeart),
              tooltip: 'Agregar a favoritos',
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text('Agregar a favoritos'),
                  content: Text(
                      'El elemento será agregado a tus favoritos\n¿Quieres continuar?'),
                  actions: [
                    TextButton(
                      child: Text('Cancelar',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                    ),
                    TextButton(
                      child: Text('Continuar',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                      onPressed: () async {
                        Navigator.pop(context, 'Continuar');

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Procesando...')));

                        Future<bool> added =
                            FavList.addToFavorites(this.song_id, {
                          'img_url': this.albumImg,
                          'song_title': this.songTitle,
                          'artist': this.artistName,
                          'song_url': this.linkList
                        });

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(await added == true
                                ? 'Agregado a favoritos...'
                                : 'Esta canción ya se encuentra en favoritos')));
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10)
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Image.network(
                '$albumImg',
                height: imgSize,
              ),
              SizedBox(height: 50),
              Text('$songTitle',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0)),
              Text('$albumTitle',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
              Text('$artistName',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16.0)),
              Text('$publishDate',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16.0)),
              SizedBox(height: 30),
              Divider(),
              Text('Abrir con:'),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(FontAwesomeIcons.spotify),
                    iconSize: this.iconSize,
                    tooltip: 'Ver en Spotify',
                    onPressed: () async {
                      _launchUrl('${this.linkSpotify}');
                    },
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.podcast),
                    iconSize: this.iconSize,
                    tooltip: 'Ver links',
                    onPressed: () async {
                      _launchUrl('${this.linkList}');
                    },
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.apple),
                    iconSize: this.iconSize,
                    tooltip: 'Ver en Apple Music',
                    onPressed: () async {
                      _launchUrl('${this.linkApple}');
                    },
                  )
                ],
              )
            ],
          ),
        ));
  }
}
