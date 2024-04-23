import 'dart:convert';

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
      final data = jsonDecode(jsonEncode(event.snapshot.value));
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

}