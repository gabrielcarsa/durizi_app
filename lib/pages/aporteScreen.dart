import 'package:durizi_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/Aporte.dart';
import '../providers/AporteProvider.dart';
import '../providers/ClienteProvider.dart';

class AporteScreen extends StatefulWidget {
  const AporteScreen({super.key});

  @override
  State<AporteScreen> createState() => _AporteScreenState();
}

class _AporteScreenState extends State<AporteScreen> {
  // Para formatar em número
  final NumberFormat formatadorMoeda =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  //controller
  final TextEditingController _valorController = TextEditingController();

  //form
  final _formKey = GlobalKey<FormState>();

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
                  'Aportes',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              body: SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: TextFormField(
                                controller: _valorController,
                                style: const TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  filled: true,
                                  hintText:
                                      'Digite um valor para fazer um aporte',
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Preencha o valor';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Se os campos forem válidos
                                  if (_formKey.currentState!.validate()) {
                                    //data atual
                                    final agora = DateTime.now();
                                    final formatter = DateFormat('dd/MM/yyyy');
                                    final dataFormatada =
                                        formatter.format(agora);

                                    final aporteSalvar = Aporte(
                                      valor:
                                          double.parse(_valorController.text),
                                      data: dataFormatada,
                                      clienteId:
                                          clienteProvider.clienteAtual!.id!,
                                    );

                                    // Salvando Aporte no Firebase
                                    Provider.of<AporteProvider>(context,
                                            listen: false)
                                        .adicionarAporte(aporteSalvar);
                                  }
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
                                  'Solicitar Aporte',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 1,
                        padding: const EdgeInsets.only(top: 15.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                        child: ListView(
                          children: [
                            Text(
                              'Histórico',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Consumer<AporteProvider>(
                              builder: (context, aporteProvider, _) {
                                // Ordenar a lista de aportes pela data mais recente
                                final List<Aporte> aportesOrdenados = List.of(
                                    aporteProvider.aportes)
                                  ..sort((a, b) => b.data.compareTo(a.data));

                                // Exibir lista de aportes
                                return aporteProvider.isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    : buildAportesLista(context,
                                        aportesOrdenados, clienteProvider);
                              },
                            ),
                          ],
                        ),
                      ),
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

  // Lista de Aportes
  Widget buildAportesLista(BuildContext context, List<Aporte> aportesOrdenados,
      ClientesProvider clienteProvider) {
    List<Widget> aporteWidgets = aportesOrdenados.map((aporte) {
      if (aporte.clienteId == clienteProvider.clienteAtual!.id) {
        return Column(
          children: [
            ListTile(
              leading: Text(
                aporte.data,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              title: Text(
                formatadorMoeda.format(aporte.valor),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Text(
                aporte.isAprovado == true
                    ? 'Aprovado'
                    : (aporte.isRejeitado == true ? 'Rejeitado' : 'Em análise'),
                style: TextStyle(
                  color: aporte.isAprovado == true
                      ? Colors.green
                      : (aporte.isRejeitado == true
                          ? Colors.red
                          : Theme.of(context).dividerColor),
                ),
              ),
            ),
            Divider(
              color: Theme.of(context).dividerColor,
            ),
          ],
        );
      } else {
        return const SizedBox();
      }
    }).toList();
    return Column(
      children: aporteWidgets,
    );
  }
}
