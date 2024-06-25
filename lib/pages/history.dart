import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Lista de pagos',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  return Card(
                      shadowColor: Colors.black,
                      elevation: 8,
                      child: ListTile(
                        title: Text(payments[index]['nombre']),
                        subtitle: Text(
                            '${payments[index]['fecha']}\n${payments[index]['mensualidad']} - COP \$${payments[index]['monto']}'),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // TODO: Implementar la funcionalidad de editar
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // TODO: Implementar la funcionalidad de borrar
                              },
                            ),
                          ],
                        ),
                      ));
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar la funcionalidad de agregar
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
