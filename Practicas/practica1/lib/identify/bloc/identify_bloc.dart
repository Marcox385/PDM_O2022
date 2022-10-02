import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

part 'identify_event.dart';
part 'identify_state.dart';

class IdentifyBloc extends Bloc<IdentifyEvent, IdentifyState> {
  IdentifyBloc() : super(IdentifyInitial()) {
    on<IdentifyAudioEvent>(_identifySong);
  }

  FutureOr<void> _identifySong(IdentifyAudioEvent event, emit) async {
    try {
      emit(WritingAudioState());
      await _recordToFile(); // Record
      emit(SuccessWritingState());

      var _endpoint = 'https://api.audd.io/recognize';
      var _file = await getApplicationDocumentsDirectory();
      var _songBody =
          await post(Uri.parse(_endpoint), headers: <String, String>{
        'api_token': dotenv.env['API_KEY']!,
        'file': _file.path,
      });

      if (_songBody.statusCode != 400 ||
          _songBody.statusCode != HttpStatus.ok) {
        throw HttpException('Bad request');
      }

      emit(IdentifiedSuccessState(body: _songBody.body));
    } on FileSystemException catch (e) {
      emit(FailedWritingState(error: 'No se ha podido reconocer el audio\n$e'));
    } on HttpException catch (e) {
      emit(IdentifiedErrorState(error: 'Petición incorrecta\n$e'));
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _requestStoragePermission() async {
    var storagePermission = await Permission.storage.status;

    if (storagePermission == PermissionStatus.denied) {
      await Permission.storage.request();
    }

    return storagePermission == PermissionStatus.granted;
  }

  // Record and save audio
  Future<void> _recordToFile() async {
    final record = Record();

    // Lack of writing file or microphone/recording permission(s)
    if (!await _requestStoragePermission() || !await record.hasPermission()) {
      throw FileSystemException();
    }

    final dir = await getApplicationDocumentsDirectory();
    await record.start(path: '${dir.path}/recording.mp3');

    Timer(Duration(milliseconds: 5000), () async {
      await record.stop();
    });
  }
}
