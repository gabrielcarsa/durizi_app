import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/Cliente.dart';
import '../providers/ClienteProvider.dart';
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

    // Ordenar a lista de saldos por data
    saldosMesesDiferentes.sort((a, b) {
      // Dividir as strings de data em partes
      List<String> partesDataA = a.data.split('/');
      List<String> partesDataB = b.data.split('/');

      // Construir objetos DateTime a partir das partes da data
      DateTime dataA = DateTime(int.parse(partesDataA[2]), int.parse(partesDataA[1]), int.parse(partesDataA[0]));
      DateTime dataB = DateTime(int.parse(partesDataB[2]), int.parse(partesDataB[1]), int.parse(partesDataB[0]));

      // Comparar as datas e retornar o resultado
      return dataA.compareTo(dataB);
    });


    // Atualizar o estado com a lista de saldos de meses diferentes
    setState(() {
      saldosMesesDiferentes = saldosMesesDiferentes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final clienteProvider =
    Provider.of<ClientesProvider>(context, listen: false);
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
            /*Text(
              clienteProvider.clienteAtual!.nome,
              style: Theme.of(context).textTheme.bodyText1,
            ),*/
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
              padding: const EdgeInsets.only(bottom: 15.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                child: LineChartSample2(listaDeSaldos: saldosMesesDiferentes),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
