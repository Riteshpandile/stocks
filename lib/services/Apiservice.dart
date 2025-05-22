import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stocks/models/stocksmodel.dart';
import 'package:dio/dio.dart';

class Apiservice {
  static const String apikey = "d0m8sohr01qkesvja690d0m8sohr01qkesvja69g";
  static const String baseUrl = "https://finnhub.io/api/v1/";

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '${baseUrl}',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  );



   Future<StockModel> fetchQuote({
    required String symbol,
    required String sector,
  }) async {
    try {
      final response = await _dio.get(
        'quote',
        queryParameters: {'symbol': symbol, 'token': apikey},
      );

      if (response.statusCode == 200 && response.data != null) {
        return StockModel.fromQuoteJson(
          symbol: symbol,
          sector: sector,
          json: response.data,
        );
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timed out');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive timeout');
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception(
          'Bad response: ${e.response?.statusCode} - ${e.response?.statusMessage}',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }



 Future<List<StockModel>> fetchMultipleQuotes(List<Map<String, String>> stocks) async {
  List<StockModel> results = [];

  for (var stock in stocks) {
    try {
      final model = await fetchQuote(
        symbol: stock['symbol']!,
        sector: stock['sector']!,
      );
      results.add(model);
    } catch (e) {
      print('Failed to fetch ${stock['symbol']}: $e');
      // Optionally continue or return partial results
    }
  }

  return results;
}





























}
