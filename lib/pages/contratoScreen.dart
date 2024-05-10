import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Cliente.dart';
import '../providers/ClienteProvider.dart';
import '../providers/TipoTemaProvider.dart';
import 'home.dart';
//import 'dart:html' as html;

class ContratoScreen extends StatefulWidget {
  const ContratoScreen({super.key, required this.cliente});

  final Cliente cliente;

  @override
  State<ContratoScreen> createState() => _ContratoScreenState();
}

class _ContratoScreenState extends State<ContratoScreen> {
  final bool _isLoadingPDF = false;
  late Future<String?> _pdfUrlFuture;

  @override
  void initState() {
    super.initState();
    _pdfUrlFuture = Provider.of<ClientesProvider>(context, listen: false)
        .obterPDFUrlFromStorage(widget.cliente.id!);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<TipoTemaProvider>(context);

    return SafeArea(
      child: Consumer<ClientesProvider>(
        builder: (context, clienteProvider, _) {
          if (clienteProvider.clienteAtual == null) {
            return const Home();
          } else {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                foregroundColor: Theme.of(context).indicatorColor,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(
                  'Contrato',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              body: SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Tenha acesso ao seu contrato,\nbaixe agora:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w700,
                          color: themeProvider.obterTema().brightness == Brightness.dark
                              ? const Color(0xFFFFFFFF)
                              : const Color(0xFF000000),
                        ),
                      ),
                    ),
                    FutureBuilder<String?>(
                      future: _pdfUrlFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Erro: ${snapshot.error}'),
                          );
                        } else if (snapshot.hasData && snapshot.data != null) {
                          // PDF disponível
                          return _isLoadingPDF
                              ? const CircularProgressIndicator()
                              : Center(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        /*html.AnchorElement(href: snapshot.data!)
                                          ..setAttribute(
                                              'download', '${widget.cliente.nome}.pdf')..setAttribute('target', '_blank')
                                          ..click();*/
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(vertical: 5),
                                        ),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                        backgroundColor: MaterialStateProperty.all(
                                            Theme.of(context).primaryColor),
                                      ),
                                      child: Text(
                                        'Baixar PDF',
                                        style: Theme.of(context).textTheme.labelLarge,
                                      ),
                                    ),
                                  ),
                                );
                        } else {
                          // PDF não disponível
                          return const Center(
                            child: Text('Não disponível'),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
