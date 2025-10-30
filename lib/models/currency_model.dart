class Currency {
  final String currencyCode;
  final String currencyName;
  final String currencySymbol;

  Currency({
    required this.currencyCode,
    required this.currencyName,
    required this.currencySymbol,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      currencyCode: json['currencyCode'] ?? '',
      currencyName: json['currencyName'] ?? '',
      currencySymbol: json['currencySymbol'] ?? '',
    );
  }
}
