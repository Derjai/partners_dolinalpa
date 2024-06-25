import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:partners_dolinalpa/controller/partner_controller.dart';
import 'package:partners_dolinalpa/domain/model/partners.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final PartnerController _partnerController = Get.find<PartnerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Socios'),
      ),
      body: Obx(() {
        if (_partnerController.partners.isEmpty) {
          return const Center(
            child: Text('No hay socios registrados'),
          );
        }
        return ListView.builder(
            itemCount: _partnerController.partners.length,
            itemBuilder: (context, index) {
              var user = _partnerController.partners[index];
              return Card(
                  shadowColor: Colors.black,
                  elevation: 8,
                  child: ListTile(
                    title: Text(user.name,
                        style: TextStyle(
                            color: getColorEstado(
                                parterStatusToString(user.status)),
                            fontWeight: FontWeight.bold)),
                    subtitle: Text('Documento: ${user.id}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  String name = user.name;
                                  String id = user.id;
                                  return AlertDialog(
                                    title: const Text('Editar Socio'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          onChanged: (value) {
                                            id = value;
                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'Documento',
                                          ),
                                        ),
                                        TextField(
                                          onChanged: (value) {
                                            name = value;
                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'Nombre',
                                          ),
                                        )
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancelar')),
                                      TextButton(
                                          onPressed: () async {
                                            await _partnerController
                                                .updatePartner(Partner(
                                                    id: id,
                                                    name: name,
                                                    status: getPartnerStatus(
                                                        user.status
                                                            .toString())));
                                            if (!context.mounted) return;
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Editar'))
                                    ],
                                  );
                                });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Eliminar Socio'),
                                    content: const Text(
                                        '¿Está seguro que desea eliminar este socio?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancelar')),
                                      TextButton(
                                          onPressed: () async {
                                            await _partnerController
                                                .deletePartner(user.id);
                                            if (!context.mounted) return;
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Eliminar'))
                                    ],
                                  );
                                });
                          },
                        ),
                        Container(
                          width: 80,
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: getColorEstado(
                                parterStatusToString(user.status)),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(parterStatusToString(user.status),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                        )
                      ],
                    ),
                  ));
            });
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                String name = '';
                String id = '';
                return AlertDialog(
                  title: const Text('Agregar Socio'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (value) {
                          id = value;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Documento',
                        ),
                      ),
                      TextField(
                        onChanged: (value) {
                          name = value;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Nombre',
                        ),
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar')),
                    TextButton(
                        onPressed: () async {
                          await _partnerController.addPartner(Partner(
                              id: id,
                              name: name,
                              status: getPartnerStatus('Activo')));
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                        child: const Text('Agregar'))
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Color getColorEstado(String estado) {
  switch (estado) {
    case 'Activo':
      return Colors.blue;
    case 'Inactivo':
      return Colors.red;
    case 'Riesgo':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}

PartnerStatus getPartnerStatus(String status) {
  switch (status) {
    case 'Activo':
      return PartnerStatus.activo;
    case 'Inactivo':
      return PartnerStatus.inactivo;
    case 'Riesgo':
      return PartnerStatus.riesgo;
    default:
      return PartnerStatus.activo;
  }
}

String parterStatusToString(PartnerStatus status) {
  switch (status) {
    case PartnerStatus.activo:
      return 'Activo';
    case PartnerStatus.inactivo:
      return 'Inactivo';
    case PartnerStatus.riesgo:
      return 'Riesgo';
    default:
      return 'Activo';
  }
}
