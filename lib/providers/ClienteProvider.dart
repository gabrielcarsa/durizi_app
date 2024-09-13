import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Cliente.dart';

class ClientesProvider extends ChangeNotifier {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  late DatabaseReference _clientesRef;

  List<Cliente> _clientes = [];
  List<Cliente> get clientes => _clientes;

  Cliente? _clienteAtual;
  Cliente? get clienteAtual => _clienteAtual;

  //gerenciar carregamento
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ClientesProvider() {
    _clientesRef = _database.child('clientes');
    _loadClientes();
  }

  // exibir Clientes
  Future<void> _loadClientes() async {
    _clientesRef.onValue.listen((event) {
      final data = jsonDecode(jsonEncode(
          event.snapshot.value)); //solução _InternalLinkedHashMap<Object>
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
  Future<Cliente?> consultarCPFExistente(String cpf, String senha) async {
    try {
      // Verifica se algum cliente na lista possui o CPF fornecido
      final clienteComCPF = _clientes.firstWhere((c) => c.cpf == cpf && c.senha == senha);

      _clienteAtual = clienteComCPF;
      return clienteComCPF;

    } catch (e) {
      return null;
    }
  }

  // deslogar
  void logout() {
    _clienteAtual = null;
    notifyListeners();
  }

  //Carregando contrato
  Future<String?> obterPDFUrlFromStorage(String idCliente) async {
    try {
      Reference pdfReference =
          FirebaseStorage.instance.ref().child('contratos/$idCliente.pdf');
      String pdfUrl = await pdfReference.getDownloadURL();
      return pdfUrl;
    } catch (e) {
      //print('Erro ao obter URL do PDF do Storage: $e');
      return null;
    }
  }

  // Atualiza automatico saldo cliente
  Future<void> atualizarSaldoDiario(Cliente cliente) async {
    // Encontra o cliente na lista local
    final clienteIndex = _clientes.indexWhere((c) => c.id == cliente.id);
    if (clienteIndex != -1) {
      final agora = DateTime.now();
      final formatter = DateFormat('dd/MM/yyyy');
      final dataFormatada = formatter.format(agora);

      // Adiciona o novo saldo ao cliente localmente
      double saldoAtual = cliente.saldo?.last.valor ?? 0;
      String ultimaData = cliente.saldo?.last.data ?? dataFormatada;
      DateTime dataUltimaAtualizacao = formatter.parse(ultimaData);
      int diferencaDiasData = agora.difference(dataUltimaAtualizacao).inDays;

      // Se já passou mais de um dia desde a última atualização
      if (diferencaDiasData > 0) {
        double reajusteDiario = cliente.reajusteDiario;
        double novoSaldoValor =
            ((reajusteDiario * diferencaDiasData) * saldoAtual) + saldoAtual;

        Saldo novoSaldo = Saldo(
            data: dataFormatada,
            valor: double.parse(novoSaldoValor.toStringAsFixed(2)));

        _clientes[clienteIndex].saldo?.add(novoSaldo);
        notifyListeners();
        // Atualiza os dados do cliente no banco de dados
        await _clientesRef
            .child(cliente.id!)
            .child('saldo')
            .push()
            .set(novoSaldo.toJson());
      }
    }
  }
}
