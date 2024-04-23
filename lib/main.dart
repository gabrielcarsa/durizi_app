import 'package:durizi_app/pages/login.dart';
import 'package:durizi_app/providers/ClienteProvider.dart';
import 'package:durizi_app/providers/RecadoProvider.dart';
import 'package:durizi_app/providers/SaqueProvider.dart';
import 'package:durizi_app/providers/TipoTemaProvider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'layout/temas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ClientesProvider>(
          create: (_) => ClientesProvider(),
        ),
        ChangeNotifierProvider<TipoTemaProvider>(
          create: (_) => TipoTemaProvider(),
        ),
        ChangeNotifierProvider<RecadoProvider>(
          create: (_) => RecadoProvider(),
        ),
        ChangeNotifierProvider<SaqueProvider>(
          create: (_) => SaqueProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    // Acessa o Provider para obter o tipo de tema atual
    final themeProvider = Provider.of<TipoTemaProvider>(context);

    return MaterialApp(
      title: 'Durizi Investimentos App',
      theme: themeProvider.obterTema() != ThemeData.dark() ? darkTheme : lightTheme,
      debugShowCheckedModeBanner: false,
      home: const Login(),
    );
  }
}
