import 'package:partners_dolinalpa/domain/model/payments.dart';
import 'package:partners_dolinalpa/domain/repositories/i_payment_repository.dart';

class PaymentUseCase {
  final IPaymentRepository _paymentRepository;

  PaymentUseCase(this._paymentRepository);

  Future<List<Payment>> getPayments() {
    return _paymentRepository.getPayments();
  }

  Future<Payment> getPayment(String id) {
    return _paymentRepository.getPayment(id);
  }

  Future<List<Payment>> getPaymentsByDate(DateTime date) {
    return _paymentRepository.getPaymentsByDate(date);
  }

  Future<List<Payment>> getPaymentsByPartner(String partnerId) {
    return _paymentRepository.getPaymentsByPartner(partnerId);
  }

  Future<void> addPayment(Payment payment) {
    return _paymentRepository.addPayment(payment);
  }

  Future<void> patchPayment(Payment payment) {
    return _paymentRepository.patchPayment(payment);
  }

  Future<void> deletePayment(String id) {
    return _paymentRepository.deletePayment(id);
  }
}
