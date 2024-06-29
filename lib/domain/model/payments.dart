enum Month {
  enero,
  febrero,
  marzo,
  abril,
  mayo,
  junio,
  julio,
  agosto,
  septiembre,
  octubre,
  noviembre,
  diciembre,
}

class Payment {
  final String paymentId;
  final String partnerId;
  final Month subscription;
  final DateTime paymentDate;
  final double paymentAmount;

  Payment({
    required this.paymentId,
    required this.partnerId,
    required this.subscription,
    required this.paymentDate,
    required this.paymentAmount,
  });

  Payment copyWith({
    String? paymentId,
    String? partnerId,
    Month? subscription,
    DateTime? paymentDate,
    double? paymentAmount,
  }) {
    return Payment(
      paymentId: paymentId ?? this.paymentId,
      partnerId: partnerId ?? this.partnerId,
      subscription: subscription ?? this.subscription,
      paymentDate: paymentDate ?? this.paymentDate,
      paymentAmount: paymentAmount ?? this.paymentAmount,
    );
  }

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentId: json['paymentId'],
      partnerId: json['partnerId'],
      subscription: Month.values.firstWhere(
          (e) => e.toString().split('.').last == json['subscription']),
      paymentDate: DateTime.parse(json['paymentDate']),
      paymentAmount: json['paymentAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'partnerId': partnerId,
      'subscription': subscription.toString().split('.').last,
      'paymentDate': paymentDate.toIso8601String(),
      'paymentAmount': paymentAmount,
    };
  }
}
