class StockModel {
  final String symbol;
  final String sector;
  final double price;
  final double change;

  StockModel({
    required this.symbol,
    required this.sector,
    required this.price,
    required this.change,
  });

  factory StockModel.fromQuoteJson({
    required String symbol,
    required String sector,
    required Map<String, dynamic> json,
  }) {
    return StockModel(
      symbol: symbol,
      sector: sector,
      price: (json['c'] ?? 0).toDouble(),
      change: (json['d'] ?? 0).toDouble(),
    );
  }
}
