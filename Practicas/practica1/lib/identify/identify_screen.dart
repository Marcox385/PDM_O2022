import 'package:FindTrackApp/favList/favorite_screen.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/identify_bloc.dart';

class IdentifyScreen extends StatelessWidget {
  final double icon_radius = 128.0;
  const IdentifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return _mainView(context);
    // return _resultLoad();

    return Scaffold(
      body: BlocConsumer<IdentifyBloc, IdentifyState>(
          listener: ((context, state) {}),
          builder: ((context, state) {
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
        AvatarGlow(
          endRadius: icon_radius + 50,
          glowColor: Theme.of(context).primaryColor,
          child: CircleAvatar(
              child: Image.asset('assets/icon.png'), radius: icon_radius),
        ),
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
