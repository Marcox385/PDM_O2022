// IS727272 - Cordero Hernández, Marco Ricardo
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool statePerson = true, stateTimer = true, statePh1 = true, statePh2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter McFlutter'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.only(bottom: 8, left: 15, right: 15),
        decoration:
            BoxDecoration(border: Border.all(width: 2, color: Colors.grey)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.account_circle, size: 50)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Flutter McFlutter',
                        style: Theme.of(context).textTheme.headline5),
                    Text('Experienced App Developer'),
                  ],
                )
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('123 Main Street'), Text('(415) 555-0198')],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      final snackBar = SnackBar(
                          content: Text("Únete a un club con otras personas"));

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      statePerson = !statePerson;
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.accessibility,
                      color: statePerson ? Colors.black : Colors.indigo,
                    )),
                IconButton(
                    onPressed: () {
                      final snackBar = SnackBar(
                          content:
                              Text("Cuenta regresiva para el evento: 31 días"));

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      stateTimer = !stateTimer;
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.timer,
                      color: stateTimer ? Colors.black : Colors.indigo,
                    )),
                IconButton(
                    onPressed: () {
                      final snackBar =
                          SnackBar(content: Text("Llama al número 4155550198"));

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      statePh1 = !statePh1;
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.phone_android,
                      color: statePh1 ? Colors.black : Colors.indigo,
                    )),
                IconButton(
                    onPressed: () {
                      final snackBar = SnackBar(
                          content: Text("Llama al celular 3317865113"));

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      statePh2 = !statePh2;
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.phone_iphone,
                      color: statePh2 ? Colors.black : Colors.indigo,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
