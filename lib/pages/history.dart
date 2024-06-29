import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:partners_dolinalpa/controller/partner_controller.dart';
import 'package:partners_dolinalpa/controller/payment_controller.dart';
import 'package:partners_dolinalpa/domain/model/payments.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final PartnerController _partnerController = Get.find<PartnerController>();
  final PaymentController _paymentController = Get.find<PaymentController>();

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
          Obx(() {
            if (_paymentController.payments.isEmpty) {
              return const Center(
                child: Text('No hay pagos registrados'),
              );
            }
            return Expanded(
              child: ListView.builder(
                  itemCount: _paymentController.payments.length,
                  itemBuilder: (context, index) {
                    var payment = _paymentController.payments[index];
                    return Card(
                        shadowColor: Colors.black,
                        elevation: 8,
                        child: ListTile(
                          title: FutureBuilder<String>(
                              future:
                                  _partnerController.getName(payment.partnerId),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data!);
                                } else {
                                  return const Text('Cargando...');
                                }
                              }),
                          subtitle: Text(
                              '${DateFormat('dd/MM/yyyy').format(payment.paymentDate)}\n${_paymentController.monthToString(payment.subscription)} - COP \$${payment.paymentAmount}'),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        String partnerId = payment.partnerId;
                                        String month =
                                            _paymentController.monthToString(
                                                payment.subscription);
                                        double paymentAmount =
                                            payment.paymentAmount;
                                        DateTime paymentDate =
                                            payment.paymentDate;
                                        return AlertDialog(
                                            title: const Text('Editar Pago'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  onChanged: (value) {
                                                    partnerId = value;
                                                  },
                                                  decoration: const InputDecoration(
                                                      hintText:
                                                          'Documento del socio'),
                                                ),
                                                TextField(
                                                  onChanged: (value) {
                                                    month = value;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText: 'Mes'),
                                                ),
                                                TextField(
                                                  onChanged: (value) {
                                                    paymentAmount =
                                                        double.parse(value);
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText: 'Monto'),
                                                ),
                                                TextField(
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                'Fecha de pago'),
                                                    readOnly: true,
                                                    onTap: () async {
                                                      final DateTime?
                                                          pickedDate =
                                                          await showDatePicker(
                                                              context: context,
                                                              initialDate:
                                                                  DateTime
                                                                      .now(),
                                                              firstDate:
                                                                  DateTime(
                                                                      2024),
                                                              lastDate:
                                                                  DateTime(
                                                                      2030));
                                                      if (pickedDate != null) {
                                                        paymentDate =
                                                            pickedDate;
                                                      }
                                                    })
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                  onPressed: () async {
                                                    final scaffoldMessenger =
                                                        ScaffoldMessenger.of(
                                                            context);
                                                    if (await _paymentController
                                                            .paymentExists(
                                                                partnerId,
                                                                month) &&
                                                        month !=
                                                            _paymentController
                                                                .monthToString(
                                                                    payment
                                                                        .subscription)) {
                                                      const snackBar = SnackBar(
                                                          content: Text(
                                                              'El mes ingresado ya fue pago'));
                                                      scaffoldMessenger
                                                          .showSnackBar(
                                                              snackBar);
                                                      if (!context.mounted) {
                                                        return;
                                                      }
                                                      Navigator.of(context)
                                                          .pop();
                                                    } else {
                                                      Payment newPayment = Payment(
                                                          partnerId: partnerId,
                                                          paymentDate:
                                                              paymentDate,
                                                          subscription:
                                                              _paymentController
                                                                  .getMonth(
                                                                      month),
                                                          paymentAmount:
                                                              paymentAmount,
                                                          paymentId: payment
                                                              .paymentId);
                                                      await _paymentController
                                                          .updatePayment(
                                                              newPayment);
                                                      if (!context.mounted) {
                                                        return;
                                                      }
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  },
                                                  child: const Text('Guardar'))
                                            ]);
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
                                          title: const Text('Eliminar pago'),
                                          content: const Text(
                                              '¿Está seguro de eliminar este pago?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await _paymentController
                                                    .deletePayment(
                                                        payment.paymentId);
                                                if (!context.mounted) return;
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Eliminar'),
                                            ),
                                          ],
                                        );
                                      });
                                },
                              ),
                            ],
                          ),
                        ));
                  }),
            );
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                String partnerId = '';
                String monthsInput = '';
                DateTime paymentDate = DateTime.now();
                double paymentAmount = 0.0;
                String paymentId = '';
                return AlertDialog(
                    title: const Text('Agregar Pago'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          onChanged: (value) {
                            partnerId = value;
                          },
                          decoration: const InputDecoration(
                              hintText: 'Documento del socio'),
                        ),
                        TextField(
                          onChanged: (value) {
                            monthsInput = value;
                          },
                          decoration: const InputDecoration(
                              hintText:
                                  'Mensualidad (separar por coma para ingresar varias)'),
                        ),
                        TextField(
                          onChanged: (value) {
                            paymentAmount = double.parse(value);
                          },
                          decoration: const InputDecoration(hintText: 'Monto'),
                        ),
                        TextField(
                            decoration: const InputDecoration(
                                hintText: 'Fecha de pago'),
                            readOnly: true,
                            onTap: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2024),
                                  lastDate: DateTime(2030));
                              if (pickedDate != null) {
                                paymentDate = pickedDate;
                              }
                            })
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                          onPressed: () async {
                            final scaffoldMessenger =
                                ScaffoldMessenger.of(context);
                            if (!await _partnerController
                                .partnerExists(partnerId)) {
                              const snackBar = SnackBar(
                                  content: Text(
                                      'El socio con el documento ingresado no existe'));
                              scaffoldMessenger.showSnackBar(snackBar);
                              if (!context.mounted) return;
                              Navigator.of(context).pop();
                            } else {
                              List<String> months = monthsInput.split(',');
                              for (var month in months) {
                                if (await _paymentController.paymentExists(
                                    partnerId, month)) {
                                  continue;
                                } else {
                                  paymentId = _paymentController.createId(
                                      partnerId, month, paymentDate);
                                  Payment payment = Payment(
                                      partnerId: partnerId,
                                      paymentDate: paymentDate,
                                      subscription:
                                          _paymentController.getMonth(month),
                                      paymentAmount: paymentAmount,
                                      paymentId: paymentId);
                                  await _paymentController.addPayment(payment);
                                }
                              }
                              if (!context.mounted) return;
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Guardar'))
                    ]);
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
