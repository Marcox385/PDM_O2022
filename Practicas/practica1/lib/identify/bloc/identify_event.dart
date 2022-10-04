part of 'identify_bloc.dart';

abstract class IdentifyEvent extends Equatable {
  const IdentifyEvent();

  @override
  List<Object> get props => [];
}

class IdentifyAudioEvent extends IdentifyEvent {}

class AudioRecordedEvent extends IdentifyEvent {}

class AudioIdentifiedEvent extends IdentifyEvent {
  final dynamic body;

  AudioIdentifiedEvent({required this.body});

  @override
  List<Object> get props => [body];
}
