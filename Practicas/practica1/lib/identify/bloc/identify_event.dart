part of 'identify_bloc.dart';

abstract class IdentifyEvent extends Equatable {
  const IdentifyEvent();

  @override
  List<Object> get props => [];
}

class IdentifyAudioEvent extends IdentifyEvent {}
