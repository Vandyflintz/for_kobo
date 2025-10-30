class OrderStatisticsModel {
  final String label;
  final String value;

  OrderStatisticsModel({
    required this.label,
    required this.value,
  });

  factory OrderStatisticsModel.fromMap(Map<String, dynamic> map) {
    return OrderStatisticsModel(
      label: map['label'] ?? '',
      value: map['value'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'label': label,
    'value': value,
  };
}