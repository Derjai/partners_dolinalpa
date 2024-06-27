import 'package:partners_dolinalpa/domain/model/partners.dart';

abstract class IPartnerRepository {
  Future<List<Partner>> getPartners();
  Future<Partner?> getPartner(String id);
  Future<void> addPartner(Partner partner);
  Future<void> patchPartner(Partner partner);
  Future<void> deletePartner(String id);
}
