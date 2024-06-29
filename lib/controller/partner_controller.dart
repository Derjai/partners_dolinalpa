import 'package:get/get.dart';
import 'package:partners_dolinalpa/domain/model/partners.dart';
import 'package:partners_dolinalpa/domain/use_case/partner_use_case.dart';

class PartnerController extends GetxController {
  final RxList<Partner> _partners = <Partner>[].obs;
  final PartnerUseCase _partnerUseCase = Get.find();

  List<Partner> get partners => _partners;

  @override
  void onInit() {
    getPartners();
    super.onInit();
  }

  getPartners() async {
    _partners.value = await _partnerUseCase.getPartners();
  }

  getPartner(String id) async {
    return await _partnerUseCase.getPartner(id);
  }

  addPartner(Partner partner) async {
    await _partnerUseCase.addPartner(partner);
    getPartners();
  }

  updatePartner(Partner partner) async {
    await _partnerUseCase.patchPartner(partner);
    getPartners();
  }

  deletePartner(String id) async {
    await _partnerUseCase.deletePartner(id);
    partners.removeWhere((partner) => partner.id == id);
    getPartners();
  }

  Future<String> getName(String id) async {
    Partner partner = await getPartner(id);
    return partner.name;
  }

  Future<bool> partnerExists(String id) async {
    Partner? partner = await getPartner(id);
    return partner != null;
  }

  String parterStatusToString(PartnerStatus status) {
    switch (status) {
      case PartnerStatus.activo:
        return 'Activo';
      case PartnerStatus.inactivo:
        return 'Inactivo';
      case PartnerStatus.riesgo:
        return 'Riesgo';
      default:
        return 'Activo';
    }
  }
}
