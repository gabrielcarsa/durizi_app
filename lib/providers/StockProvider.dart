import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:durizi_app/models/StockJSON.dart';

class StockProvider with ChangeNotifier {
  List<Stock> _stocks = [];
  bool isLoading = false;
  String? _errorMessage;

  List<Stock> get stocks => _stocks;
  String? get errorMessage => _errorMessage;

  Future<Stock?> getStock() async {
    isLoading = true;
    notifyListeners();

    List<String> symbols = [
      'itub4',
      'petr4',
      'ggbr4',
      'vale3',
      'abev3',
    ];

    try {
      // Cria uma lista de Futures para as requisições HTTP
      final futures = symbols.map((symbol) {
        final url = 'https://brapi.dev/api/quote/$symbol?token=sDitMJtjH647iZ3CphyA1A';
        return http.get(Uri.parse(url));
      }).toList();

      // Aguarda a conclusão de todas as requisições
      final responses = await Future.wait(futures);

      _stocks = [];
      _errorMessage = null;

      for (final response in responses) {
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          // Verifique se 'results' está presente e é uma lista
          if (data['results'] != null && data['results'] is List) {
            final stockList = (data['results'] as List).map((item) => Stock.fromJson(item)).toList();
            _stocks.addAll(stockList);
          } else {
            _errorMessage = 'Dados não encontrados';
          }
        } else {
          _errorMessage = 'Erro ao carregar dados';
        }
      }
    } catch (e) {
      _errorMessage = 'Erro: $e';
    }

    isLoading = false;
    notifyListeners();
    return null;
  }
}
