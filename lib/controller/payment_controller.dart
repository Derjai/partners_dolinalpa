import 'package:get/get.dart';
import 'package:partners_dolinalpa/domain/model/payments.dart';
import 'package:partners_dolinalpa/domain/use_case/payment_use_case.dart';

class PaymentController extends GetxController {
  final RxList<Payment> _payments = <Payment>[].obs;
  final PaymentUseCase _paymentUseCase = Get.find();

  List<Payment> get payments => _payments;

  @override
  void onInit() {
    getPayments();
    super.onInit();
  }

  getPayments() async {
    _payments.value = await _paymentUseCase.getPayments();
  }

  getPayment(String id) async {
    return await _paymentUseCase.getPayment(id);
  }

  addPayment(Payment payment) async {
    await _paymentUseCase.addPayment(payment);
    getPayments();
  }

  updatePayment(Payment payment) async {
    await _paymentUseCase.patchPayment(payment);
    getPayments();
  }

  deletePayment(String id) async {
    await _paymentUseCase.deletePayment(id);
    payments.removeWhere((payment) => payment.paymentId == id);
    getPayments();
  }

  getPaymentsByPartner(String partnerId) async {
    return await _paymentUseCase.getPaymentsByPartner(partnerId);
  }

  getPaymentsByDate(DateTime date) async {
    return await _paymentUseCase.getPaymentsByDate(date);
  }

  Month getMonth(String month) {
    switch (month) {
      case 'Enero':
        return Month.enero;
      case 'Febrero':
        return Month.febrero;
      case 'Marzo':
        return Month.marzo;
      case 'Abril':
        return Month.abril;
      case 'Mayo':
        return Month.mayo;
      case 'Junio':
        return Month.junio;
      case 'Julio':
        return Month.julio;
      case 'Agosto':
        return Month.agosto;
      case 'Septiembre':
        return Month.septiembre;
      case 'Octubre':
        return Month.octubre;
      case 'Noviembre':
        return Month.noviembre;
      case 'Diciembre':
        return Month.diciembre;
      default:
        return Month.enero;
    }
  }

  String monthToString(Month month) {
    switch (month) {
      case Month.enero:
        return 'Enero';
      case Month.febrero:
        return 'Febrero';
      case Month.marzo:
        return 'Marzo';
      case Month.abril:
        return 'Abril';
      case Month.mayo:
        return 'Mayo';
      case Month.junio:
        return 'Junio';
      case Month.julio:
        return 'Julio';
      case Month.agosto:
        return 'Agosto';
      case Month.septiembre:
        return 'Septiembre';
      case Month.octubre:
        return 'Octubre';
      case Month.noviembre:
        return 'Noviembre';
      case Month.diciembre:
        return 'Diciembre';
      default:
        return 'Enero';
    }
  }

  String createId(String partnerId, String month, DateTime paymentDate) {
    return '${partnerId}_${paymentDate.year}_$month';
  }

  Future<bool> paymentExists(String id, String month) async {
    List<Payment>? payments = await getPaymentsByPartner(id);
    if (payments == null) return false;
    String year = DateTime.now().year.toString();
    bool exists = payments.any((payment) {
      String paymentYear = payment.paymentDate.year.toString();
      String paymentMonth = monthToString(payment.subscription);
      return paymentYear == year && paymentMonth == month;
    });
    return exists;
  }
}
