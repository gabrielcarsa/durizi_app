import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/Cliente.dart';

class ClientesProvider extends ChangeNotifier {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late DatabaseReference _clientesRef;

  List<Cliente> _clientes = [];
  List<Cliente> get clientes => _clientes;

  Cliente? _clienteAtual;
  Cliente? get clienteAtual => _clienteAtual;

  ClientesProvider() {
    _clientesRef = _database.child('clientes');
    _loadClientes();
  }

  // exibir Clientes
  Future<void> _loadClientes() async {
    _clientesRef.onValue.listen((event) {
      final data = jsonDecode(jsonEncode(event.snapshot.value)); //solução _InternalLinkedHashMap<Object>

      if (data != null && data is Map) {
        _clientes = data.entries
            .map((entry) => Cliente.fromJson(entry.value, entry.key))
            .toList();
      } else {
        _clientes = [];
      }
      notifyListeners();
    });
  }

  // Logar com CPF
  Future<Cliente?> consultarCPFExistente(String cpf) async {
    try {
      // Verifica se algum cliente na lista possui o CPF fornecido
      final clienteComCPF = _clientes.firstWhere((c) => c.cpf == cpf);

      if (clienteComCPF != null) {

        // Ordenar a lista de saldos por data
        clienteComCPF.saldo?.sort((a, b) {
          // Dividir as strings de data em partes
          List<String> partesDataA = a.data.split('/');
          List<String> partesDataB = b.data.split('/');

          // Construir objetos DateTime a partir das partes da data
          DateTime dataA = DateTime(int.parse(partesDataA[2]),
              int.parse(partesDataA[1]), int.parse(partesDataA[0]));
          DateTime dataB = DateTime(int.parse(partesDataB[2]),
              int.parse(partesDataB[1]), int.parse(partesDataB[0]));

          // Comparar as datas e retornar o resultado
          return dataA.compareTo(dataB);
        });

        _clienteAtual = clienteComCPF;
        return clienteComCPF;
      }
    } catch (e) {
      return null;
    }
  }
}
