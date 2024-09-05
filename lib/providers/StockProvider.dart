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

  Future<Stock?> getStock(String symbol) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('https://brapi.dev/api/quote/petr4?token=sDitMJtjH647iZ3CphyA1A'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _errorMessage = null;

        // Supondo que 'results' é a chave que contém a lista de ações
        if (data['results'] != null && data['results'] is List) {
          _stocks = (data['results'] as List).map((item) => Stock.fromJson(item)).toList();
        } else {
          _errorMessage = 'Dados não encontrados';
          _stocks = [];
        }
      } else {
        _errorMessage = 'Erro ao carregar dados';
      }
    } catch (e) {
      _errorMessage = 'Erro: $e';
    }

    isLoading = false;
    notifyListeners();
  }
}
