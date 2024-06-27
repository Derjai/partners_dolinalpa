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
}
