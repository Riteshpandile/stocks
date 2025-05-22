import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stocks/models/stocksmodel.dart';
import 'package:stocks/services/Apiservice.dart';


final apiServiceProvider = Provider<Apiservice>((ref) => Apiservice());


final singleStockProvider = FutureProvider.family<StockModel, Map<String, String>>((ref, stock) async {
  final api = ref.read(apiServiceProvider);
  return await api.fetchQuote(
    symbol: stock['symbol']!,
    sector: stock['sector']!,
  );
});


final stockListProvider = FutureProvider<List<StockModel>>((ref) async {
  final api = ref.read(apiServiceProvider);

  final List<Map<String, String>> stockList = [
    {'symbol': 'AAPL', 'sector': 'Technology'},
    {'symbol': 'MSFT', 'sector': 'Technology'},
    {'symbol': 'GOOGL', 'sector': 'Technology'},
    {'symbol': 'TSLA', 'sector': 'Automotive'},
    {'symbol': 'JPM', 'sector': 'Finance'},
  ];

  return await api.fetchMultipleQuotes(stockList);
});
