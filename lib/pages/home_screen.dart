import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:partners_dolinalpa/controller/partner_controller.dart';
import 'package:partners_dolinalpa/controller/payment_controller.dart';
import 'package:partners_dolinalpa/domain/model/partners.dart';
import 'package:partners_dolinalpa/domain/model/payments.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isExpandedP = true;
  bool _isExpandedS = true;
  List<Partner> filtered = [];
  final PaymentController _paymentController = Get.find<PaymentController>();
  final PartnerController _partnerController = Get.find<PartnerController>();
  List<Payment>? payments;
  List<Partner>? partners;

  @override
  void initState() {
    super.initState();
    payments = _paymentController.payments;
    partners = _partnerController.partners;
    orderByDate(payments!);
    filtered = partners!;
  }

  void orderByDate(List<Payment> payments) {
    payments.sort((a, b) => b.paymentDate.compareTo(a.paymentDate));
  }

  void filterPartners(String value) {
    setState(() {
      filtered = partners!.where((partner) {
        return partner.name.toLowerCase().contains(value.toLowerCase());
      }).toList();
    });
  }

  void reloadView() {
    setState(() {
      payments = _paymentController.payments;
      partners = _partnerController.partners;
      orderByDate(payments!);
      filtered = partners!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Resumen'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: reloadView,
            ),
          ],
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
                              children: payments!
                                  .take(3)
                                  .map((payment) => Card(
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
                                                      FutureBuilder<String>(
                                                          future: _partnerController
                                                              .getName(payment
                                                                  .partnerId),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasData) {
                                                              return Text(
                                                                snapshot.data!,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .displaySmall,
                                                              );
                                                            } else {
                                                              return const Text(
                                                                  'Cargando...');
                                                            }
                                                          }),
                                                      Text(
                                                          'Mensualidad: ${_paymentController.monthToString(payment.subscription)}'),
                                                      Text(
                                                          'Fecha de pago: ${DateFormat('dd/MM/yyyy').format(payment.paymentDate)}'),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )),
                                      ))
                                  .toList()))
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
                              onChanged: filterPartners,
                            ),
                            ...filtered.map((partner) => Card(
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
                                                  partner.name,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                    'Estado: ${_partnerController.parterStatusToString(partner.status)}'),
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
