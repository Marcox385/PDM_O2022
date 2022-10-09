import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FavItem extends StatelessWidget {
  final String albumImg, songTitle, artistName, linkList;

  FavItem(
      {super.key,
      required this.albumImg,
      required this.songTitle,
      required this.artistName,
      required this.linkList});

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
                        _launchUrl('$linkList');
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
              child: Image.network('$albumImg'),
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
                        "$songTitle",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "$artistName",
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
