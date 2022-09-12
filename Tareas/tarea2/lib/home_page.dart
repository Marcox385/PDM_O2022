// 727272 - Cordero Hernández, Marco Ricardo
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var serviceController = TextEditingController(); // Para el valor del servicio
  bool rounded = false; // Para la función de redondeo
  int? currentRadio = 0; // Para indicar la opción de propina
  String? tipAmount = "0.0"; // Cantidad de propina formateada como cadena

  /* Valores de propina; pueden agregarse más mediante la sintaxis
     [Descripción] - [Porcentaje]% */
  var amounts = {0: 'Amazing - 20%', 1: 'Good - 18%', 2: 'Okay - 15%'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tip time'),
        backgroundColor: Color(0xff4cb051),
      ),
      body: ListView(
        children: [
          SizedBox(height: 14),
          ListTile(
            leading: Icon(Icons.room_service),
            title: Padding(
              padding: EdgeInsets.only(right: 24),
              child: TextField(
                controller: serviceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    label: Text('Cost of service'),
                    border: OutlineInputBorder()),
                onChanged: (String str) {
                  setState(() {}); // Para asegurar funcionamiento de error
                },
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dinner_dining),
            title: Text("How was the service?"),
          ),
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: radioGroupGenerator(amounts),
            ),
          ),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text("Round up tip"),
            trailing: Switch(
              value: rounded,
              activeColor: Color(0xff4cb051),
              onChanged: (bool value) {
                setState(() {
                  rounded = value;
                });
              },
            ),
          ),
          Container(
              margin: EdgeInsetsDirectional.only(start: 15.0, end: 15.0),
              child: MaterialButton(
                child: Text("CALCULATE"),
                color: Color(0xff4cb051),
                textColor: Colors.white,
                onPressed: (serviceController.text.isNotEmpty)
                    ? () {
                        _tipCalculation();
                        setState(() {});
                      }
                    : () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text('ERROR'),
                              content: Text('Valores faltantes o erróneos'),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: Text('Ok'))
                              ],
                            )),
              )),
          Container(
            margin: EdgeInsetsDirectional.only(top: 8.0, end: 15.0),
            child: Text(
              "Tip amount: \$$tipAmount",
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  void _tipCalculation() {
    List<String> holder = amounts[currentRadio]!.split(" ");
    String tipString = holder[holder.length - 1].split("%")[0];

    try {
      double helper = double.parse(serviceController.text) *
          (double.parse(tipString) / 100);

      tipAmount = helper.toStringAsFixed(2);

      if (rounded) tipAmount = helper.ceil().toString();
    } catch (_) {
      tipAmount = "0.0";
    }
  }

  radioGroupGenerator(Map<int, String> elems) {
    return elems.entries
        .map(
          (radioElement) => ListTile(
            title: Text("${radioElement.value}"),
            leading: Radio(
              value: radioElement.key,
              groupValue: currentRadio,
              activeColor: Color(0xff4cb051),
              onChanged: (int? selected) {
                currentRadio = selected;
                setState(() {});
              },
            ),
          ),
        )
        .toList();
  }
}
