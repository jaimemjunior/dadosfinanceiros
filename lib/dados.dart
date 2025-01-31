import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dados extends StatefulWidget {
  const Dados({Key? key}) : super(key: key);

  @override
  State<Dados> createState() => _DadosState();
}

class _DadosState extends State<Dados> {
  var request = Uri.https('api.hgbrasil.com', '/finance', {'key': '60df7606'});

  Future<Map> getDados() async {
    http.Response response = await http.get(request);
    return json.decode(response.body);
  }

  String dateNow() {
    DateTime dt = DateTime.now();
    String day = dt.day.toString();
    String month = dt.month.toString();
    String year = dt.year.toString();

    return '$day/$month/$year';
  }

  String cutNumber(double number) {
    return number.toStringAsPrecision(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dados Financeiros',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder<Map>(
            future: getDados(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                    child: Text('Carregando ...'),
                  );
                default:
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar'),
                    );
                  } else {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: SafeArea(
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.monetization_on,
                                  size: 70,
                                  color: Colors.green,
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  'Cotação para o dia:' + dateNow(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                                Text(
                                  'Dolar: R\$ ' +
                                      (cutNumber(snapshot.data!['results']
                                      ['currencies']['USD']['buy'])),
                                  style: const TextStyle(
                                      fontSize: 25, fontWeight: FontWeight.w700),
                                ),
                                const Divider(),
                                Text(
                                  'Euro R\$ ' +
                                      cutNumber(snapshot.data!['results']
                                      ['currencies']['EUR']['buy']),
                                  style: const TextStyle(
                                      fontSize: 25, fontWeight: FontWeight.w700),
                                ),
                                const Divider(),
                                Text(
                                    'Ibovespa: ' +
                                        snapshot.data!['results']['stocks']
                                        ['IBOVESPA']['variation']
                                            .toString() +
                                        '%',
                                    style: (snapshot.data!['results']['stocks']
                                    ['IBOVESPA']['variation'] >=
                                        0)
                                        ? const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.green)
                                        : const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red)),
                                const SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        ));
                  }
              }
            },
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.source), label: 'hgbrasil.com'),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.copyright,
              color: Colors.blue,
            ),
            label: 'JaimeMJr',
          ),
          //BottomNavigationBarItem(icon: Icon(Icons.remove), label: 'teste3'),
        ],
      ),
    );
  }
}
