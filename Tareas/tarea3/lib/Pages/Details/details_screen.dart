import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class DetailsScreen extends StatefulWidget {
  final String imgUrl, title, publishDate, pages, description;
  DetailsScreen(
      {super.key,
      required this.imgUrl,
      required this.title,
      required this.publishDate,
      required this.pages,
      required this.description});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool shortened = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del libro'),
        actions: [
          Icon(Icons.public),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(
                  'Título: ${widget.title}\nNúmero de páginas: ${widget.pages}',
                  subject: '¡Excelente libro!');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, right: 20.0, top: 45.0, bottom: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: (widget.imgUrl == '')
                  ? Image.asset('assets/no_cover.jpg', scale: 1.5)
                  : Image.network(widget.imgUrl, scale: 0.65),
            ),
            SizedBox(height: 30.0),
            Center(
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 35.0),
            Text(widget.publishDate,
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Páginas: ${widget.pages}',
              textAlign: TextAlign.left,
            ),
            Expanded(
              flex: 1,
              child: new SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: GestureDetector(
                      child: Text(
                        widget.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontStyle: FontStyle.italic),
                        overflow: (this.shortened)
                            ? TextOverflow.ellipsis
                            : TextOverflow.visible,
                        maxLines: (this.shortened) ? 6 : null,
                      ),
                      onTap: () {
                        this.shortened = !this.shortened;
                        setState(() {});
                      })),
            )
          ],
        ),
      ),
    );
  }
}
