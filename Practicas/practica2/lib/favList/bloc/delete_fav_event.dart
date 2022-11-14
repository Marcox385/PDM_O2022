part of 'delete_fav_bloc.dart';

abstract class DeleteFavEvent extends Equatable {
  const DeleteFavEvent();

  @override
  List<Object> get props => [];
}

class DeleteRequestedEvent extends DeleteFavEvent {
  final dynamic song_id;

  DeleteRequestedEvent({required this.song_id});

  @override
  List<Object> get props => [song_id];
}

class FavListEnterEvent extends DeleteFavEvent {}