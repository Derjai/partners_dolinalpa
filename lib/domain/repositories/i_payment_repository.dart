import 'package:partners_dolinalpa/domain/model/payments.dart';

abstract class IPaymentRepository {
  Future<List<Payment>> getPayments();
  Future<Payment> getPayment(String id);
  Future<List<Payment>> getPaymentsByDate(DateTime date);
  Future<List<Payment>> getPaymentsByPartner(String partnerId);
  Future<void> addPayment(Payment payment);
  Future<void> patchPayment(Payment payment);
  Future<void> deletePayment(String id);
}
