part of 'identify_bloc.dart';

abstract class IdentifyState extends Equatable {
  const IdentifyState();

  @override
  List<Object> get props => [];
}

class IdentifyInitial extends IdentifyState {} // Still animation

class WritingAudioState extends IdentifyState {} // Writing audio file

class SuccessWritingState extends IdentifyState {} // File saved

class FailedWritingState extends IdentifyState { // File not saved
  final String error;

  FailedWritingState({required this.error});
}

class IdentifiedSuccessState extends IdentifyState { // Song identified
  final dynamic body;

  IdentifiedSuccessState({required this.body});

  @override
  List<Object> get props => [body];
}

class IdentifiedErrorState extends IdentifyState { // Song not identified
  final String error;

  IdentifiedErrorState({required this.error});
}
