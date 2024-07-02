import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:partners_dolinalpa/domain/model/payments.dart';
import 'package:partners_dolinalpa/domain/repositories/i_payment_repository.dart';

class FirestorePaymentsRepository implements IPaymentRepository {
  final CollectionReference _paymentsCollection =
      FirebaseFirestore.instance.collection('payments');

  @override
  Future<void> addPayment(Payment payment) async {
    try {
      await _paymentsCollection.doc(payment.paymentId).set(payment.toJson());
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception('No tienes permisos para acceder a los datos');
      }
      if (e.code == 'unavailable') {
        throw Exception('No se pudo conectar al repositorio de pagos');
      }
      throw Exception('Error al agregar socio: ${e.message}');
    } catch (e) {
      throw Exception('Error desconocido: ${e.toString()}');
    }
  }

  @override
  Future<void> deletePayment(String id) async {
    try {
      await _paymentsCollection.doc(id).delete();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception('No tienes permisos para acceder a los datos');
      }
      if (e.code == 'unavailable') {
        throw Exception('No se pudo conectar al repositorio de pagos');
      }
      throw Exception('Error al agregar socio: ${e.message}');
    } catch (e) {
      throw Exception('Error desconocido: ${e.toString()}');
    }
  }

  @override
  Future<Payment?> getPayment(String id) async {
    try {
      final docSnapshot = await _paymentsCollection.doc(id).get();
      return Payment.fromJson(docSnapshot.data() as Map<String, dynamic>)
          .copyWith(paymentId: docSnapshot.id);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception('No tienes permisos para acceder a los datos');
      }
      if (e.code == 'unavailable') {
        throw Exception('No se pudo conectar al repositorio de pagos');
      }
      throw Exception('Error al obtener pago: ${e.message}');
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Payment>> getPayments() async {
    try {
      final querySnapshot = await _paymentsCollection.get();
      final paymentsList = querySnapshot.docs
          .map((doc) => Payment.fromJson(doc.data() as Map<String, dynamic>)
              .copyWith(paymentId: doc.id))
          .toList();
      return paymentsList;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception('No tienes permisos para acceder a los datos');
      }
      if (e.code == 'unavailable') {
        throw Exception('No se pudo conectar al repositorio de pagos');
      }
      throw Exception('Error al obtener pagos: ${e.message}');
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> patchPayment(Payment payment) async {
    try {
      await _paymentsCollection.doc(payment.paymentId).update(payment.toJson());
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception('No tienes permisos para acceder a los datos');
      }
      if (e.code == 'unavailable') {
        throw Exception('No se pudo conectar al repositorio de pagos');
      }
      throw Exception('Error al actualizar pago: ${e.message}');
    } catch (e) {
      throw Exception('Error desconocido: ${e.toString()}');
    }
  }

  @override
  Future<List<Payment>> getPaymentsByDate(DateTime date) async {
    try {
      final querySnapshot =
          await _paymentsCollection.where('paymentDate', isEqualTo: date).get();
      return querySnapshot.docs
          .map((doc) => Payment.fromJson(doc.data() as Map<String, dynamic>)
              .copyWith(paymentId: doc.id))
          .toList();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception('No tienes permisos para acceder a los datos');
      }
      if (e.code == 'unavailable') {
        throw Exception('No se pudo conectar al repositorio de pagos');
      }
      throw Exception('Error al obtener pagos: ${e.message}');
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Payment>> getPaymentsByPartner(String partnerId) async {
    try {
      final querySnapshot = await _paymentsCollection
          .where('partnerId', isEqualTo: partnerId)
          .get();
      return querySnapshot.docs
          .map((doc) => Payment.fromJson(doc.data() as Map<String, dynamic>)
              .copyWith(paymentId: doc.id))
          .toList();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception('No tienes permisos para acceder a los datos');
      }
      if (e.code == 'unavailable') {
        throw Exception('No se pudo conectar al repositorio de pagos');
      }
      throw Exception('Error al obtener pagos: ${e.message}');
    } catch (e) {
      return [];
    }
  }
}
