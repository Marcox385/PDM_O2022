import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleFavScreen extends StatelessWidget {
  final double imgSize = 370, iconSize = 50;

  final String songTitle, albumTitle, artistName, publishDate;

  const SingleFavScreen(
      {super.key,
      required this.songTitle,
      required this.albumTitle,
      required this.artistName,
      required this.publishDate});

  Future<void> _launchUrl(String rawUrl) async {
    Uri _url = Uri.parse(rawUrl);

    if (!await launchUrl(_url)) {
      throw 'Unable to launch URL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Here you go'),
          actions: [Icon(FontAwesomeIcons.solidHeart), SizedBox(width: 10)],
        ),
        body: Center(
          child: Column(
            children: [
              Image.network(
                'https://m.media-amazon.com/images/I/713N4ZIYsEL._AC_SX522_.jpg',
                height: imgSize,
              ),
              SizedBox(height: 50),
              Text('$songTitle',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0)),
              Text('$albumTitle',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0)),
              Text('$artistName',
                  style: TextStyle(color: Colors.grey, fontSize: 16.0)),
              Text('$publishDate',
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
                      _launchUrl(
                          'https://open.spotify.com/album/20r762YmB5HeofjMCiPMLv');
                    },
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.podcast),
                    iconSize: this.iconSize,
                    tooltip: 'Ver links',
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.apple),
                    iconSize: this.iconSize,
                    tooltip: 'Ver en Apple Music',
                    onPressed: () {},
                  )
                ],
              )
            ],
          ),
        ));
  }
}
