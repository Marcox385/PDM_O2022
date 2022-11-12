import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FavItem extends StatelessWidget {
  final String song_id, img_url, song_title, artist, song_url;

  FavItem({
    super.key,
    required this.song_id,
    required this.img_url,
    required this.song_title,
    required this.artist,
    required this.song_url,
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
                        _launchUrl('$song_url');
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
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network('$img_url', fit: BoxFit.cover),
              ),
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
                      color: Theme.of(context).primaryColor.withOpacity(0.85),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5))),
                  child: Column(
                    children: [
                      Text(
                        "$song_title",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "$artist",
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
                  icon: Icon(
                    FontAwesomeIcons.solidHeart,
                    color: Colors.red,
                  ),
                  onPressed: () {} // TODO
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
