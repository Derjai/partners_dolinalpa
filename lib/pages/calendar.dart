import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:partners_dolinalpa/controller/partner_controller.dart';
import 'package:partners_dolinalpa/controller/payment_controller.dart';
import 'package:partners_dolinalpa/domain/model/payments.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final PaymentController _paymentController = Get.find<PaymentController>();
  final PartnerController _partnerController = Get.find<PartnerController>();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Payment>? payments;
  Map<DateTime, List<Payment>> events = {};

  @override
  void initState() {
    super.initState();
    _initPayments();
  }

  void _initPayments() {
    var paymentsResult = _paymentController.payments;
    setState(
      () {
        payments = paymentsResult;
        events = _mapPaymentsToEvents(payments);
      },
    );
  }

  Map<DateTime, List<Payment>> _mapPaymentsToEvents(List<Payment>? payments) {
    Map<DateTime, List<Payment>> eventsMap = {};
    if (payments != null) {
      for (var payment in payments) {
        DateTime date = DateTime(payment.paymentDate.year,
            payment.paymentDate.month, payment.paymentDate.day);
        if (eventsMap[date] == null) {
          eventsMap[date] = [];
        }
        eventsMap[date]!.add(payment);
      }
    }
    return eventsMap;
  }

  List<Payment> _getEventsForSelectedDay() {
    if (_selectedDay != null) {
      DateTime selectedDayDateOnly =
          DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
      for (var key in events.keys) {
        DateTime keyDateOnly = DateTime(key.year, key.month, key.day);
        if (keyDateOnly == selectedDayDateOnly) {
          return events[key] ?? [];
        }
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
      ),
      body: Column(
        children: [
          TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                focusedDay = focusedDay;
              },
              eventLoader: (day) {
                return events[DateTime(day.year, day.month, day.day)] ?? [];
              }),
          Expanded(
            child: ListView.builder(
                itemCount: _getEventsForSelectedDay().length,
                itemBuilder: (context, index) {
                  var event = _getEventsForSelectedDay()[index];
                  return ListTile(
                    title: FutureBuilder<String>(
                        future: _partnerController.getName(event.partnerId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data!);
                          } else {
                            return const Text('Cargando...');
                          }
                        }),
                    subtitle: Text(
                        '${_paymentController.monthToString(event.subscription)} - COP \$${event.paymentAmount}'),
                  );
                }),
          )
        ],
      ),
    );
  }
}
