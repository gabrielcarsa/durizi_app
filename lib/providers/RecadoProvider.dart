import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/Recado.dart';

class RecadoProvider extends ChangeNotifier {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late DatabaseReference _recadosRef;

  List<Recado> _recados = [];

  List<Recado> get recados => _recados;

  RecadoProvider() {
    _recadosRef = _database.child('recados');
    _loadRecados();
  }

  // exibir Recados
  Future<void> _loadRecados() async {
    _recadosRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        _recados = data.entries
            .map((entry) => Recado.fromJson(entry.value, entry.key))
            .toList();
      } else {
        _recados = [];
      }
      notifyListeners();
    });
  }

  // Adiciona recados
  Future<void> adicionarRecados(Recado recado) async {
    await _recadosRef.push().set(recado.toJson());
  }

  // Excluir recado
  Future<void> excluirRecado(Recado recado) async {
    // Encontra o recado na lista local
    final recadoIndex = _recados.indexWhere((r) => r.id == recado.id);

    if (recadoIndex != -1) {
      // Remove o recado da lista local
      _recados.removeAt(recadoIndex);
      notifyListeners();

      // Remove os dados do recado do banco de dados
      await _recadosRef.child(recado.id!).remove();
    }
  }

  // Ativa ou desativa Recado
  Future<void> ativarOuDesativarRecado(Recado recado, bool isAtivo) async {
    // Encontra o recado na lista local
    final recadoIndex = _recados.indexWhere((r) => r.id == recado.id);
    if (recadoIndex != -1) {

      // Atualiza o recado na lista local
      _recados[recadoIndex].setIsAtivo(isAtivo);
      notifyListeners();
      // atualiza recado no banco de dados
      await _recadosRef.child(recado.id!).set(recado.toJson());
    }
  }
}