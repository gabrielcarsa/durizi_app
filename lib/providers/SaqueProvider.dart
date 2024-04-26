import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/Saque.dart';

class SaqueProvider extends ChangeNotifier {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late DatabaseReference _saquesRef;

  List<Saque> _saques = [];
  List<Saque> get saques => _saques;

  //gerenciar carregamento
  bool _isLoading = false;
  bool get isLoading => _isLoading;


  SaqueProvider() {
    _saquesRef = _database.child('saques');
    carregarSaques();
  }

  // exibir Saques
  Future<void> carregarSaques() async {
    _isLoading = true;
    _saquesRef.onValue.listen((event) {
      final data = jsonDecode(jsonEncode(event.snapshot.value));
      if (data != null && data is Map) {
        _saques = data.entries
            .map((entry) => Saque.fromJson(entry.value, entry.key))
            .toList();
      } else {
        _saques = [];
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  // Adiciona Saques
  Future<void> adicionarSaque (Saque saque) async {
    await _saquesRef.push().set(saque.toJson());
  }

  // Excluir Saque
  Future<void> excluirSaque(Saque saque) async {
    // Encontra o saque na lista local
    final saqueIndex = _saques.indexWhere((c) => c.id == saque.id);

    if (saqueIndex != -1) {
      // Remove o saque da lista local
      _saques.removeAt(saqueIndex);
      notifyListeners();

      // Remove os dados do saque do banco de dados
      await _saquesRef.child(saque.id!).remove();
    }
  }

}