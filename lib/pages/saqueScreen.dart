import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/Saque.dart';
import '../providers/ClienteProvider.dart';
import '../providers/SaqueProvider.dart';
import 'home.dart';

class SaqueScreen extends StatefulWidget {
  const SaqueScreen({super.key});

  @override
  State<SaqueScreen> createState() => _SaqueScreenState();
}

class _SaqueScreenState extends State<SaqueScreen> {
  // Para formatar em número
  final NumberFormat formatadorMoeda =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  //controller
  final TextEditingController _valorController = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');

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
                  'Saques',
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
                                keyboardType: TextInputType.number,
                                controller: _valorController,
                                style: const TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  filled: true,
                                  hintText: 'Digite um valor para sacar',
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

                                    final saqueSalvar = Saque(
                                      valor: double.parse(
                                        _valorController.text
                                            .replaceAll('.', '')
                                            .replaceAll(',', '.'),
                                      ),
                                      data: dataFormatada,
                                      clienteId:
                                          clienteProvider.clienteAtual!.id!,
                                    );

                                    // Salvando Saque no Firebase
                                    Provider.of<SaqueProvider>(context,
                                            listen: false)
                                        .adicionarSaque(saqueSalvar);
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
                                  'Solicitar Saque',
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
                            Consumer<SaqueProvider>(
                              builder: (context, saqueProvider, _) {
                                // Ordenar a lista de saques pela data mais recente
                                final List<Saque> saquesOrdenados = List.of(
                                    saqueProvider.saques)
                                  ..sort((a, b) => b.data.compareTo(a.data));

                                // Exibir lista de saques
                                return saqueProvider.isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      )
                                    : buildSaquesLista(context, saquesOrdenados,
                                        clienteProvider);
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

  Widget buildSaquesLista(BuildContext context, List<Saque> saquesOrdenados,
      ClientesProvider clienteProvider) {
    List<Widget> saqueWidgets = saquesOrdenados.map((saque) {
      if (saque.clienteId == clienteProvider.clienteAtual!.id) {
        return Column(
          children: [
            ListTile(
              leading: Text(
                saque.data,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              title: Text(
                formatadorMoeda.format(saque.valor),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Text(
                saque.isAprovado == true
                    ? 'Aprovado'
                    : (saque.isRejeitado == true ? 'Rejeitado' : 'Em análise'),
                style: TextStyle(
                  color: saque.isAprovado == true
                      ? Colors.green
                      : (saque.isRejeitado == true
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
      children: saqueWidgets,
    );
  }
}
