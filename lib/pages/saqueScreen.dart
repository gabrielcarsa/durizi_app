import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(
                  'Saques',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              body: SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                child: Column(
                  children: [
                    Consumer<SaqueProvider>(
                      builder: (context, saqueProvider, _) {
                        List<Widget> saqueWidgets =
                            saqueProvider.saques.map((saque) {
                          return Column(
                            children: [
                              ListTile(
                                leading: Text(
                                  saque.data,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                title: Text(
                                  formatadorMoeda.format(saque.valor),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                trailing: Text(
                                  saque.isAprovado == true
                                      ? 'Aprovado'
                                      : (saque.isRejeitado == true
                                          ? 'Rejeitado'
                                          : 'Em análise'),
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
                        }).toList();
                        return Column(
                          children: saqueWidgets,
                        );
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
