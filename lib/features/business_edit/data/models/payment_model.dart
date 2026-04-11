class PaymentModel {
  const PaymentModel({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: _readInt(json['PaymentMethodId']),
      name: _readString(json['PaymentMethodName'], fallback: 'Payment Method'),
      isSelected: _readBool(json['IsMethodSelected']),
    );
  }

  final int id;
  final String name;
  final bool isSelected;

  PaymentModel copyWith({
    int? id,
    String? name,
    bool? isSelected,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _readString(dynamic value, {String fallback = ''}) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? fallback : text;
  }

  static bool _readBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }

    final normalized = value?.toString().trim().toLowerCase() ?? '';
    return normalized == 'true' || normalized == '1';
  }
}
