import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:partners_dolinalpa/domain/model/partners.dart';
import 'package:partners_dolinalpa/domain/repositories/i_partner_repository.dart';

class FirestorePartnersRepository implements IPartnerRepository {
  final CollectionReference _partnersCollection =
      FirebaseFirestore.instance.collection('partners');

  @override
  Future<List<Partner>> getPartners() async {
    try {
      final querySnapshot = await _partnersCollection.get();
      final partnersList = querySnapshot.docs
          .map((doc) => Partner.fromJson(doc.data() as Map<String, dynamic>)
              .copyWith(id: doc.id))
          .toList();
      if (partnersList.isEmpty) {
        throw Exception('No hay socios registrados');
      }
      return partnersList;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception('No tienes permisos para acceder a los datos');
      }
      if (e.code == 'unavailable') {
        throw Exception('No se pudo conectar al repositorio de socios');
      }
      throw Exception('Error al obtener socios: ${e.message}');
    } catch (e) {
      throw Exception('Error desconocido: ${e.toString()}');
    }
  }

  @override
  Future<Partner> getPartner(String id) async {
    try {
      final docSnapshot = await _partnersCollection.doc(id).get();
      if (docSnapshot.exists) {
        return Partner.fromJson(docSnapshot.data() as Map<String, dynamic>)
            .copyWith(id: docSnapshot.id);
      } else {
        throw Exception('Usuario no encontrado');
      }
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception('No tienes permisos para acceder a los datos');
      }
      if (e.code == 'unavailable') {
        throw Exception('No se pudo conectar al repositorio de socios');
      }
      throw Exception('Error al obtener socio: ${e.message}');
    } catch (e) {
      throw Exception('Error desconocido: ${e.toString()}');
    }
  }

  @override
  Future<void> addPartner(Partner partner) async {
    try {
      await _partnersCollection.doc(partner.id).set(partner.toJson());
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception('No tienes permisos para acceder a los datos');
      }
      if (e.code == 'unavailable') {
        throw Exception('No se pudo conectar al repositorio de socios');
      }
      throw Exception('Error al agregar socio: ${e.message}');
    } catch (e) {
      throw Exception('Error desconocido: ${e.toString()}');
    }
  }

  @override
  Future<void> deletePartner(String id) async {
    try {
      await _partnersCollection.doc(id).delete();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception('No tienes permisos para acceder a los datos');
      }
      if (e.code == 'unavailable') {
        throw Exception('No se pudo conectar al repositorio de socios');
      }
      throw Exception('Error al eliminar socio: ${e.message}');
    } catch (e) {
      throw Exception('Error desconocido: ${e.toString()}');
    }
  }

  @override
  Future<void> patchPartner(Partner partner) async {
    try {
      await _partnersCollection.doc(partner.id).update(partner.toJson());
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw Exception('No tienes permisos para acceder a los datos');
      }
      if (e.code == 'unavailable') {
        throw Exception('No se pudo conectar al repositorio de socios');
      }
      throw Exception('Error al actualizar socio: ${e.message}');
    } catch (e) {
      throw Exception('Error desconocido: ${e.toString()}');
    }
  }
}
