import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import '../models/Cliente.dart';
import '../providers/ClienteProvider.dart';
import 'home.dart';

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
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              body: SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 1,
                child: FutureBuilder<String?>(
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
                    }  else if (snapshot.hasData && snapshot.data != null) {
                      // PDF disponível
                      return _isLoadingPDF
                          ? const CircularProgressIndicator()
                          : Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            final pdfUrl = snapshot.data!;
                            final taskId = await FlutterDownloader.enqueue(
                              url: pdfUrl,
                              savedDir: 'directory_name',
                              fileName: '${widget.cliente.nome}.pdf',
                              showNotification: true, // Mostrar notificação no sistema quando o download estiver concluído.
                              openFileFromNotification: true, // Abra o arquivo diretamente quando o download estiver concluído (funciona apenas em Android).
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF5964FB),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text('Baixar o contrato'),
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
              ),
            );
          }
        },
      ),
    );
  }
}
