import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchTriggeredEvent>(_search);
  }

  FutureOr<void> _search(SearchTriggeredEvent event, emit) async {
    emit(LoadingState());

    try {
      if (event.query.length == 0) {
        emit(SearchInitial());
        return;
      }

      var _request = await http.get(Uri.parse(
          'https://www.googleapis.com/books/v1/volumes?q=' + event.query));

      if (_request.statusCode != 200 || _request.statusCode != HttpStatus.ok) {
        emit(FailedState());
        return;
      }

      dynamic _results = JsonDecoder().convert(_request.body);
      int qty = _results['totalItems'];

      emit(LoadedState(qty: qty, results: (qty != 0) ? _results['items'] : {}));
    } catch (e) {
      emit(FailedState());
    }
  }
}
