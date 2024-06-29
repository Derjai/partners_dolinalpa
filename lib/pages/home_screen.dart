import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isExpandedP = true;
  bool _isExpandedS = true;
  final List<Map<String, dynamic>> payments = [
    {
      'nombre': 'Martha Morales',
      'fecha': '24 de junio 2024',
      'mensualidad': 'Mayo',
      'monto': '100000',
    },
    {
      'nombre': 'Martha Morales',
      'fecha': '24 de mayo 2024',
      'mensualidad': 'Abril',
      'monto': '100000',
    },
    {
      'nombre': 'Martha Morales',
      'fecha': '24 de mayo 2024',
      'mensualidad': 'Marzo',
      'monto': '300000',
    },
  ];

  final List<Map<String, dynamic>> users = [
    {
      'nombre': 'Martha Morales',
      'estado': 'Activo',
    },
    {
      'nombre': 'Juan Pérez',
      'estado': 'Inactivo',
    },
    {
      'nombre': 'Luisa Fernanda',
      'estado': 'Riesgo',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Resumen'),
        ),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendario'),
              onTap: () {
                Navigator.pushNamed(context, '/calendar');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Socios'),
              onTap: () {
                Navigator.pushNamed(context, '/partners');
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Pagos'),
              onTap: () {
                Navigator.pushNamed(context, '/history');
              },
            ),
          ],
        )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Últimos pagos',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('Lista de últimos pagos',
                                    style: TextStyle(fontSize: 14)),
                              ],
                            )),
                        Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.calendar_month),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/calendar');
                                }),
                            IconButton(
                                icon: Icon(_isExpandedP
                                    ? Icons.expand_less
                                    : Icons.expand_more),
                                onPressed: () {
                                  setState(() {
                                    _isExpandedP = !_isExpandedP;
                                  });
                                }),
                          ],
                        )
                      ],
                    ),
                    if (_isExpandedP)
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              children: List.generate(
                                  3,
                                  (index) => Card(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        payments[index]
                                                            ['nombre'],
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                          'Mensualidad: ${payments[index]['mensualidad']}'),
                                                      Text(
                                                          'Fecha de pago: ${payments[index]['fecha']}'),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                      ))))
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Lista de Socios',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        IconButton(
                            icon: Icon(_isExpandedS
                                ? Icons.expand_less
                                : Icons.expand_more),
                            onPressed: () {
                              setState(() {
                                _isExpandedS = !_isExpandedS;
                              });
                            })
                      ],
                    ),
                    if (_isExpandedS)
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            TextField(
                              decoration: const InputDecoration(
                                  labelText: 'Buscar Socio',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.search)),
                              onChanged: (value) {},
                            ),
                            ...List.generate(
                                3,
                                (index) => Card(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      users[index]['nombre'],
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                        'Estado: ${users[index]['estado']}'),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                    ))
                          ]))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
