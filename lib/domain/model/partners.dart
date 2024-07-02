enum PartnerStatus { activo, inactivo, riesgo }

class Partner {
  final String id;
  final String name;
  final PartnerStatus status;

  Partner({required this.id, required this.name, required this.status});

  Partner copyWith({
    String? id,
    String? name,
    PartnerStatus? status,
  }) {
    return Partner(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'],
      name: json['name'],
      status: PartnerStatus.values
          .firstWhere((e) => e.toString().split('.').last == json["status"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      "status": status.toString().split('.').last,
    };
  }
}
