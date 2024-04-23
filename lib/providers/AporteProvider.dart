import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/Aporte.dart';

class AporteProvider extends ChangeNotifier {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late DatabaseReference _aportesRef;

  List<Aporte> _aportes = [];
  List<Aporte> get aportes => _aportes;

  AporteProvider() {
    _aportesRef = _database.child('aportes');
    _carregarAportes();
  }

  // exibir Aportes
  Future<void> _carregarAportes() async {
    _aportesRef.onValue.listen((event) {
      final data = jsonDecode(jsonEncode(event.snapshot.value));
      if (data != null && data is Map) {
        _aportes = data.entries
            .map((entry) => Aporte.fromJson(entry.value, entry.key))
            .toList();
      } else {
        _aportes = [];
      }
      notifyListeners();
    });
  }

  // Adiciona Aportes
  Future<void> adicionarAporte (Aporte aporte) async {
    await _aportesRef.push().set(aporte.toJson());
  }

  // Excluir Aporte
  Future<void> excluirAporte(Aporte aporte) async {
    // Encontra o aporte na lista local
    final aporteIndex = _aportes.indexWhere((c) => c.id == aporte.id);

    if (aporteIndex != -1) {
      // Remove o aporte da lista local
      _aportes.removeAt(aporteIndex);
      notifyListeners();

      // Remove os dados do aporte do banco de dados
      await _aportesRef.child(aporte.id!).remove();
    }
  }
}