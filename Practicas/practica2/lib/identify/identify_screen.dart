import 'dart:convert';

import 'package:findtrackapp_v2/favList/bloc/delete_fav_bloc.dart';
import 'package:findtrackapp_v2/favList/favorite_screen.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:findtrackapp_v2/favList/single_fav_screen.dart';
import 'package:findtrackapp_v2/login/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

          if (response['result'] == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('No se encontraron resultados\nIntente de nuevo...'),
              duration: Duration(milliseconds: 5000),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ));
            return;
          }

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleFavScreen(
                        song_id: response['result']['spotify']?['id'] ?? '',
                        songTitle: response['result']['title'] ?? '',
                        albumTitle: response['result']['album'] ?? '',
                        artistName: response['result']['artist'] ?? '',
                        publishDate: response['result']['release_date'] ?? '',
                        linkSpotify: response['result']['spotify']
                                ?['external_urls']['spotify'] ??
                            '',
                        linkList: response['result']['song_link'] ?? '',
                        linkApple:
                            response['result']['apple_music']?['url'] ?? '',
                        albumImg: response['result']['spotify']?['album']
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  BlocProvider.of<DeleteFavBloc>(context).add(FavListEnterEvent());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FavoriteScreen()));
                },
              ),
            ),
            Tooltip(
              message: 'Cerrar sesión',
              child: ElevatedButton(
                child: Icon(FontAwesomeIcons.powerOff, color: Colors.black),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(CircleBorder()),
                  padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  AuthService().signOut();
                },
              ),
            )
          ],
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
