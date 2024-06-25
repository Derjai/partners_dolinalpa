import 'package:partners_dolinalpa/domain/model/partners.dart';

import '../repositories/i_partner_repository.dart';

class PartnerUseCase {
  final IPartnerRepository _partnerRepository;

  PartnerUseCase(this._partnerRepository);

  Future<List<Partner>> getPartners() {
    return _partnerRepository.getPartners();
  }

  Future<Partner> getPartner(String id) {
    return _partnerRepository.getPartner(id);
  }

  Future<void> addPartner(Partner partner) {
    return _partnerRepository.addPartner(partner);
  }

  Future<void> patchPartner(Partner partner) {
    return _partnerRepository.patchPartner(partner);
  }

  Future<void> deletePartner(String id) {
    return _partnerRepository.deletePartner(id);
  }
}
