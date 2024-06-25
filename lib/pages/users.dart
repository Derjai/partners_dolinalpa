import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final List<Map<String, dynamic>> users = [
    {
      'nombre': 'Martha Morales',
      'documento': '49692740',
      'estado': 'Activo',
      'colorEstado': Colors.blue,
    },
    {
      'nombre': 'Juan Pérez',
      'documento': '12345678',
      'estado': 'Inactivo',
      'colorEstado': Colors.red,
    },
    {
      'nombre': 'Luisa Fernanda',
      'documento': '87654321',
      'estado': 'Riesgo',
      'colorEstado': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Socios'),
      ),
      body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return Card(
                shadowColor: Colors.black,
                elevation: 8,
                child: ListTile(
                  title: Text(users[index]['nombre'],
                      style: TextStyle(
                          color: users[index]['colorEstado'],
                          fontWeight: FontWeight.bold)),
                  subtitle: Text('Documento: ${users[index]['documento']}'),
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
                      Container(
                        width: 80,
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: users[index]['colorEstado'],
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(users[index]['estado'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                      )
                    ],
                  ),
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar la funcionalidad de agregar
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
