import 'package:flutter/material.dart';

// Enum para representar os tipos de tema
enum ThemeType { light, dark }

// Classe para o provedor de tema
class TipoTemaProvider with ChangeNotifier {
  // Variável privada para armazenar o tema atual
  ThemeType _themeType = ThemeType.dark;

  // Método para obter o tema atual
  ThemeType get themeType => _themeType;

  // Método para alternar entre temas
  void alterarTema() {
    _themeType = _themeType == ThemeType.light ? ThemeType.dark : ThemeType.light;
    // Notifique os ouvintes de que o tema mudou
    notifyListeners();
  }

  // Método para obter o ThemeData com base no tema atual
  ThemeData obterTema() {
    switch (_themeType) {
      case ThemeType.dark:
        return ThemeData.dark();
      case ThemeType.light:
        return ThemeData.light();
      default:
        return ThemeData.dark();
    }
  }
}
