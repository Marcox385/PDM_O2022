import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:findtrackapp_v2/secrets.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

part 'identify_event.dart';
part 'identify_state.dart';

class IdentifyBloc extends Bloc<IdentifyEvent, IdentifyState> {
  IdentifyBloc() : super(IdentifyInitial()) {
    on<IdentifyAudioEvent>(_identifySong);
    on<AudioRecordedEvent>(_audioRecorded);
    on<AudioIdentifiedEvent>(_audioIdentified);
  }

  void _audioRecorded(AudioRecordedEvent event, emit) {
    emit(SuccessWritingState());
  }

  void _audioIdentified(AudioIdentifiedEvent event, emit) {
    emit(IdentifiedSuccessState(body: event.body));
  }

  Future _identifySong(IdentifyAudioEvent event, emit) async {
    try {
      emit(WritingAudioState());
      await _recordToFile().then((value) {
        Future.delayed(Duration(milliseconds: 5000), () {
          add(AudioRecordedEvent());
        }).then((value) {
          Future.delayed(Duration(milliseconds: 1000), () async {
            var _endpoint = 'https://api.audd.io/recognize';
            var _filePath = await getApplicationDocumentsDirectory();
            var _fileBinary =
                await File(_filePath.path + '/recording.mp3').readAsBytes();

            var _request = await http.post(Uri.parse(_endpoint), body: {
              'api_token': API_KEY,
              'return': 'apple_music,spotify',
              'audio': base64.encode(_fileBinary),
            });

            if (_request.statusCode != 200 ||
                _request.statusCode != HttpStatus.ok) {
              emit(IdentifiedErrorState(error: 'Petición incorrecta'));
            }

            add(AudioIdentifiedEvent(body: _request.body));
          });
        });
      });
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
  Future<bool> _recordToFile() async {
    final record = Record();

    // Lack of writing file or microphone/recording permission(s)
    if (!await _requestStoragePermission() || !await record.hasPermission()) {
      throw FileSystemException();
    }

    final dir = await getApplicationDocumentsDirectory();
    await record.start(path: '${dir.path}/recording.mp3');

    Future.delayed(Duration(milliseconds: 5000), () async {
      await record.stop();
      return true;
    });

    return false;
  }
}
