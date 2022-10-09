import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarea3/Pages/Details/details_screen.dart';
import 'bloc/search_bloc.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController query = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String initial = 'Ingrese palabra para buscar libro',
        notFound = 'No se encontró ningún libro',
        netError = 'Error de conexión\nIntenta más tarde',
        genError = 'Ocurrió un error inesperado\nVuelve a intentar';

    return Scaffold(
      appBar: AppBar(title: Text('Librería free to play')),
      body: Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
        child: Column(
          children: [
            _searchBar(context),
            BlocConsumer<SearchBloc, SearchState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is SearchInitial)
                  return _placeholderText(initial);
                else if (state is LoadingState)
                  return _gridResults(null, context, loading: true);
                else if (state is LoadedState) {
                  if (int.parse(context
                          .read<SearchBloc>()
                          .state
                          .props[0]
                          .toString()) >
                      0) {
                    dynamic resList = context.read<SearchBloc>().state.props[1];
                    return _gridResults(resList, context);
                  } else
                    return _placeholderText(notFound);
                } else if (state is FailedState)
                  return _placeholderText(netError);
                else
                  return _placeholderText(genError);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _searchBar(context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
          controller: query,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              splashRadius: 25.0,
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                BlocProvider.of<SearchBloc>(context)
                    .add(SearchTriggeredEvent(query: query.text));
              },
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            labelText: 'Ingresa título',
          )),
    );
  }

  Widget _placeholderText(String body) {
    return Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(body),
      ],
    ));
  }

  Widget _gridResults(dynamic results, context, {bool loading = false}) {
    _shimmerDisplay() {
      return Column(
        children: [
          SizedBox(
            width: 150.0,
            height: 190.0,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[400]!,
              highlightColor: Colors.grey[300]!,
              child: Container(
                width: double.infinity,
                height: 8.0,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20.0),
          SizedBox(
            width: 150.0,
            height: 30.0,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[400]!,
              highlightColor: Colors.grey[300]!,
              child: Container(
                width: double.infinity,
                height: 8.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    _actualResults(dynamic results, int index) {
      var current = results[index]['volumeInfo'];

      _pager() {
        return Navigator.push(context, MaterialPageRoute(builder: (context) {
          String pages = (current['pageCount'] == null)
              ? 'N/A'
              : current['pageCount'].toString();

          return DetailsScreen(
              imgUrl: (current['imageLinks'] == null)
                  ? ''
                  : current['imageLinks']['thumbnail'],
              title: current['title'],
              publishDate: current['publishedDate'],
              pages: pages,
              description: current['description'] ?? '-');
        }));
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              child: (current['imageLinks'] == null)
                  ? Image.asset(
                      'assets/no_cover.jpg',
                      scale: 2.25,
                    )
                  : Image.network(current['imageLinks']['thumbnail']),
              onTap: () => _pager()),
          GestureDetector(
            child: Text(
              current['title'],
              style: TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            onTap: () => _pager,
          )
        ],
      );
    }

    return Expanded(
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 0),
          itemCount: loading ? 10 : results?.length,
          physics: loading ? NeverScrollableScrollPhysics() : null,
          itemBuilder: (context, index) {
            return Container(
                alignment: Alignment.center,
                child: loading
                    ? _shimmerDisplay()
                    : _actualResults(results!, index));
          }),
    );
  }
}
