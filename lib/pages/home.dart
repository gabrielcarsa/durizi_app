import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/Cliente.dart';
import '../providers/ClienteProvider.dart';
import '../providers/TipoTemaProvider.dart';
import '../widgets/grafico_evolucao.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Saldos
  List<Saldo> saldosMesesDiferentes = [];

  // Para formatar em número
  final NumberFormat formatadorMoeda =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void initState() {
    final clienteProvider =
        Provider.of<ClientesProvider>(context, listen: false);

    super.initState();
    // Lista para armazenar os meses já encontrados
    List<String> mesesEncontrados = [];

    // Iterar sobre a lista de saldos do cliente
    for (Saldo saldo in clienteProvider.clienteAtual?.saldo ?? []) {
      // Obter o mês da data do saldo
      String mesAtual = saldo.data.substring(3, 5);
      // Verificar se o mês não está na lista de meses encontrados
      if (!mesesEncontrados.contains(mesAtual)) {
        // Adicionar o saldo à lista de saldos de meses diferentes
        saldosMesesDiferentes.add(saldo);

        // Adicionar o mês à lista de meses encontrados
        mesesEncontrados.add(mesAtual);
      }
    }

    // Atualizar o estado com a lista de saldos de meses diferentes
    setState(() {
      saldosMesesDiferentes = saldosMesesDiferentes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final clienteProvider =
        Provider.of<ClientesProvider>(context, listen: false);
    clienteProvider.clienteAtual?.saldo?.forEach((element) {
      print(element.valor);
    });

    Cliente clienteAtual = clienteProvider.clienteAtual!;
    double evolucaoSaldo = 0;
    double diferenca = 0;

    if (clienteAtual.saldo != null && clienteAtual.saldo!.isNotEmpty) {
      // Acesso seguro ao saldo quando não é nulo e não está vazio
      double saldoAtual = clienteAtual.saldo!.last.valor;
      double saldoInicio = clienteAtual.saldo!.first.valor;
      diferenca = saldoAtual - saldoInicio;
      evolucaoSaldo = (diferenca / saldoInicio) * 100;
      // Arredondando para duas casas decimais
      evolucaoSaldo = double.parse(evolucaoSaldo.toStringAsFixed(2));
    }

    final themeProvider = Provider.of<TipoTemaProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 100,
        elevation: 0,
        title: Container(
          height: 100.0,
          width: 100.0,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/logo-em-branco.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).indicatorColor,
              size: 30,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Patrimônio',
              style: TextStyle(
                fontSize: 14.0,
                color: Color(0xFF9F9F9F),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              formatadorMoeda
                  .format(clienteProvider.clienteAtual!.saldo?.last.valor ?? 0),
              style: Theme.of(context).textTheme.headline1,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child:
                        LineChartSample2(listaDeSaldos: saldosMesesDiferentes),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '+ ${formatadorMoeda.format(diferenca)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'de ganhos',
                        style: themeProvider.obterTema() != ThemeData.dark()
                            ? const TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF9F9F9F),
                                fontWeight: FontWeight.w400,
                              )
                            : const TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.w400,
                              ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        '+ $evolucaoSaldo %',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'de evolução',
                        style: themeProvider.obterTema() != ThemeData.dark()
                            ? const TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF9F9F9F),
                                fontWeight: FontWeight.w400,
                              )
                            : const TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.w400,
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              'Ações',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 5.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.attach_money,
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Aporte',
                      style: TextStyle(
                        color: Theme.of(context).indicatorColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.money_off,
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Saque',
                      style: TextStyle(
                        color: Theme.of(context).indicatorColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.document_scanner_sharp,
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Contrato',
                      style: TextStyle(
                        color: Theme.of(context).indicatorColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        size: 40,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Sobre',
                      style: TextStyle(
                        color: Theme.of(context).indicatorColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            Text(
              'Recados',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 5.0,
            ),
          ],
        ),
      ),
    );
  }
}
