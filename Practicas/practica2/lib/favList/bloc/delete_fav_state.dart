part of 'delete_fav_bloc.dart';

abstract class DeleteFavState extends Equatable {
  const DeleteFavState();

  @override
  List<Object> get props => [];
}

class DeleteFavInitial extends DeleteFavState {}
class DeleteRequestedState extends DeleteFavState {}

class UpdatedListState extends DeleteFavState {
  final dynamic favList;

  UpdatedListState({required this.favList});

  @override
  List<Object> get props => [favList];
}

class LoadedListState extends DeleteFavState {
  final dynamic favList;

  LoadedListState({required this.favList});

  @override
  List<Object> get props => [favList];
}