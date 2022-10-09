import 'package:FindTrackApp/favList/fav_list.dart';
import 'package:FindTrackApp/identify/identify_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleFavScreen extends StatelessWidget {
  final double imgSize = 370, iconSize = 50;

  final String albumImg,
      songTitle,
      albumTitle,
      artistName,
      publishDate,
      linkSpotify,
      linkList,
      linkApple;

  const SingleFavScreen(
      {super.key,
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
              onPressed: () {
                // FavList.addSong(, values)
              },
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
