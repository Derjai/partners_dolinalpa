import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:partners_dolinalpa/controller/partner_controller.dart';
import 'package:partners_dolinalpa/controller/payment_controller.dart';
import 'package:partners_dolinalpa/domain/model/payments.dart';

class PaymentsScreen extends StatefulWidget {
  final String idSocio;
  const PaymentsScreen({super.key, required this.idSocio});
  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final PartnerController _partnerController = Get.find<PartnerController>();
  final PaymentController _paymentController = Get.find<PaymentController>();
  List<Payment>? payments;

  @override
  void initState() {
    super.initState();
    _initPayments();
  }

  void _initPayments() async {
    var paymentsResult =
        await _paymentController.getPaymentsByPartner(widget.idSocio);
    setState(() {
      payments = paymentsResult;
    });
  }

  void reloadView() {
    _initPayments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: reloadView,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<String>(
                  future: _partnerController.getName(widget.idSocio),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!,
                        style: Theme.of(context).textTheme.displayMedium,
                      );
                    } else {
                      return const Text('Cargando...');
                    }
                  })),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text('Historial de pagos'),
          ),
          Expanded(
            child: payments == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: payments!.length,
                    itemBuilder: (context, index) {
                      var payment = payments![index];
                      return Card(
                          shadowColor: Colors.black,
                          elevation: 8,
                          child: ListTile(
                            title: Text(DateFormat('dd/MM/yyyy')
                                .format(payment.paymentDate)),
                            subtitle: Text(
                                '${_paymentController.monthToString(payment.subscription)} - COP \$${payment.paymentAmount}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          String month =
                                              _paymentController.monthToString(
                                                  payment.subscription);
                                          DateTime paymentDate =
                                              payment.paymentDate;
                                          double paymentAmount =
                                              payment.paymentAmount;
                                          return AlertDialog(
                                            title: const Text('Editar pago'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  onChanged: (value) {
                                                    month = value;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              'Mensualidad'),
                                                ),
                                                TextField(
                                                  onChanged: (value) {
                                                    paymentAmount =
                                                        double.parse(value);
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              'Monto del pago'),
                                                ),
                                                TextField(
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                'Fecha de pago'),
                                                    readOnly: true,
                                                    onTap: () async {
                                                      final DateTime?
                                                          pickdDate =
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
                                                      if (pickdDate != null) {
                                                        paymentDate = pickdDate;
                                                      }
                                                    })
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child:
                                                      const Text('Cancelar')),
                                              TextButton(
                                                  onPressed: () async {
                                                    final scaffoldMessenger =
                                                        ScaffoldMessenger.of(
                                                            context);
                                                    if (await _paymentController
                                                            .paymentExists(
                                                                widget.idSocio,
                                                                month) &&
                                                        month !=
                                                            _paymentController
                                                                .monthToString(
                                                                    payment
                                                                        .subscription)) {
                                                      const snackBar = SnackBar(
                                                        content: Text(
                                                            'El mes ingresado ya fue pago'),
                                                      );
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
                                                          partnerId:
                                                              widget.idSocio,
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
                                                      _initPayments();
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  },
                                                  child: const Text('Guardar'))
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
                                            title: const Text('Eliminar pago'),
                                            content: const Text(
                                                '¿Está seguro que desea eliminar este pago?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child:
                                                      const Text('Cancelar')),
                                              TextButton(
                                                  onPressed: () async {
                                                    await _paymentController
                                                        .deletePayment(
                                                            payment.paymentId);
                                                    if (!context.mounted) {
                                                      return;
                                                    }
                                                    _initPayments();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('Eliminar'))
                                            ],
                                          );
                                        });
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
          showDialog(
              context: context,
              builder: (BuildContext context) {
                String partnerId = widget.idSocio;
                String monthsInput = '';
                DateTime paymentDate = DateTime.now();
                double paymentAmount = 0;
                String paymentId = '';
                return AlertDialog(
                  title: const Text('Agregar pago'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                          onChanged: (value) {
                            monthsInput = value;
                          },
                          decoration: const InputDecoration(
                              hintText:
                                  'Mensualidad (separar por coma para ingresar varias)')),
                      TextField(
                        onChanged: (value) {
                          paymentAmount = double.parse(value);
                        },
                        decoration:
                            const InputDecoration(hintText: 'Monto del pago'),
                      ),
                      TextField(
                          decoration:
                              const InputDecoration(hintText: 'Fecha de pago'),
                          readOnly: true,
                          onTap: () async {
                            final DateTime? pickdDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2024),
                                lastDate: DateTime(2030));
                            if (pickdDate != null) {
                              paymentDate = pickdDate;
                            }
                          })
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
                                Payment newPayment = Payment(
                                    paymentId: paymentId,
                                    partnerId: partnerId,
                                    subscription:
                                        _paymentController.getMonth(month),
                                    paymentDate: paymentDate,
                                    paymentAmount: paymentAmount);
                                await _paymentController.addPayment(newPayment);
                              }
                            }
                            if (!context.mounted) return;
                            _initPayments();
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Guardar'))
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
