import 'package:flutter/material.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});
  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final List<Map<String, dynamic>> payments = [
    {
      'fecha': '24 de junio 2024',
      'mensualidad': 'Mayo',
      'monto': '100000',
    },
    {
      'fecha': '24 de mayo 2024',
      'mensualidad': 'Abril',
      'monto': '100000',
    },
    {
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
              'Martha Morales',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text('Historial de pagos'),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  return Card(
                      shadowColor: Colors.black,
                      elevation: 8,
                      child: ListTile(
                        title: Text(payments[index]['fecha']),
                        subtitle: Text(
                            '${payments[index]['mensualidad']} - COP \$${payments[index]['monto']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.calendar_month),
                              onPressed: () {
                                // TODO: Implementar la funcionalidad de ver detalle
                              },
                            ),
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
