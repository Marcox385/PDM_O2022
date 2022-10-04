import 'dart:convert';

import 'package:FindTrackApp/favList/favorite_screen.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/identify_bloc.dart';

class IdentifyScreen extends StatelessWidget {
  final double icon_radius = 128.0;
  const IdentifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<IdentifyBloc, IdentifyState>(
          listener: ((context, state) {
        if (state is IdentifiedSuccessState) {
          var response =
              jsonDecode(context.read<IdentifyBloc>().state.props[0].toString())
                  as Map<String, dynamic>;

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleFavScreen(
                        songTitle: response['result']['title'] ?? '',
                        albumTitle: response['result']['album'] ?? '',
                        artistName: response['result']['artist'] ?? '',
                        publishDate: response['result']['release_date'] ?? '',
                        linkSpotify: response['result']['spotify']
                                ['external_urls']['spotify'] ??
                            '',
                        linkList: response['result']['song_link'] ?? '',
                        linkApple:
                            response['result']['apple_music']['url'] ?? '',
                        albumImg: response['result']['spotify']['album']
                                ['images'][0]['url'] ??
                            '',
                      )));
        }
      }), builder: ((context, state) {
        if (state is IdentifyInitial)
          return _mainView(context);
        else if (state is WritingAudioState)
          return _recordingView(context);
        else if (state is SuccessWritingState)
          return _resultLoad();
        else
          return _mainView(context);
      })),
    );
  }

  Widget _mainView(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.only(top: 80, bottom: 80),
          child: Text('Toque para escuchar',
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        AvatarGlow(
          endRadius: icon_radius + 50,
          duration: Duration(milliseconds: 0),
          repeat: false,
          child: GestureDetector(
            child: CircleAvatar(
                child: Image.asset('assets/icon.png'), radius: icon_radius),
            onTap: () {
              BlocProvider.of<IdentifyBloc>(context).add(IdentifyAudioEvent());
            },
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Tooltip(
          message: 'Ver favoritos',
          child: ElevatedButton(
            child: Icon(FontAwesomeIcons.solidHeart, color: Colors.black),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(CircleBorder()),
              padding: MaterialStateProperty.all(EdgeInsets.all(12)),
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FavoriteScreen()));
            },
          ),
        )
      ]),
    );
  }

  Widget _recordingView(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.only(top: 80, bottom: 80),
          child: Text('Escuchando...',
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        Animated(icon_radius: icon_radius),
        SizedBox(
          height: 40,
        )
      ]),
    );
  }

  Widget _resultLoad() {
    return Center(
      child: Text('Esperando respuesta...'),
    );
  }
}

class Animated extends StatelessWidget {
  const Animated({
    Key? key,
    required this.icon_radius,
  }) : super(key: key);

  final double icon_radius;

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      endRadius: icon_radius + 50,
      duration: Duration(milliseconds: 1000),
      repeat: true,
      glowColor: Theme.of(context).primaryColor,
      child: CircleAvatar(
          child: Image.asset('assets/icon.png'), radius: icon_radius),
    );
  }
}

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
          title: Text('Here you go'),
          actions: [Icon(FontAwesomeIcons.solidHeart), SizedBox(width: 10)],
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
