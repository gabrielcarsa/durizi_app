import 'package:carousel_slider/carousel_slider.dart';
import 'package:durizi_app/pages/aporteScreen.dart';
import 'package:durizi_app/pages/saqueScreen.dart';
import 'package:durizi_app/providers/RecadoProvider.dart';
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

  final PageController _pageController = PageController();

  @override
  void initState() {
    final clienteProvider =
        Provider.of<ClientesProvider>(context, listen: false);

    super.initState();
    // Lista para armazenar os meses já encontrados
    List<String> mesesEncontrados = [];

    // Armazenar saldo do Mes Atual para depois exibir o mais atual
    List<Saldo> saldosMesAtual = [];

    //Variavel para obter o mes e ano da data de hoje
    String mesAnoAtual = DateFormat('MM/yyyy').format(DateTime.now());

    // Iterar sobre a lista de saldos do cliente
    for (Saldo saldo in clienteProvider.clienteAtual?.saldo ?? []) {
      // Obter o mês da data do saldo do for
      String mesAtualSaldo = saldo.data.substring(3, 5);

      // Obter o mẽs e ano da data do saldo do for
      String mesAnoAtualSaldo = saldo.data.substring(3);

      // Verificar se o mês não está na lista de meses encontrados
      if (!mesesEncontrados.contains(mesAtualSaldo)) {
        //Verificar se não é o mes Atual
        if (mesAnoAtualSaldo != mesAnoAtual) {
          // Adicionar o mês à lista de meses encontrados
          mesesEncontrados.add(mesAtualSaldo);
          // Adicionar o saldo à lista de saldos de meses diferentes
          saldosMesesDiferentes.add(saldo);
        } else {
          saldosMesAtual.add(saldo);
        }
      }
    }
    saldosMesesDiferentes.add(saldosMesAtual.last);

    // Atualizar o estado com a lista de saldos de meses diferentes
    setState(() {
      saldosMesesDiferentes = saldosMesesDiferentes;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Providers
    final themeProvider = Provider.of<TipoTemaProvider>(context);
    final recadosProvider = Provider.of<RecadoProvider>(context);
    final clienteProvider =
        Provider.of<ClientesProvider>(context, listen: false);

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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      endDrawer: Drawer(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 2,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_circle_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Olá, ',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            TextSpan(
                              text: clienteAtual.nome,
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    themeProvider.obterTema().brightness == Brightness.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    'Alterar para modo claro',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              onTap: () {
                //alterar tema
                themeProvider.alterarTema();
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    'Sair',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              onTap: () {
                //logout
                clienteProvider.logout();
              },
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Desenvolvido por GHC Tecnologia',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF9F9F9F),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
      ),
      body: SingleChildScrollView(
        child: Container(
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
                formatadorMoeda.format(saldosMesesDiferentes.last.valor),
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
                      child: LineChartSample2(
                          listaDeSaldos: saldosMesesDiferentes),
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
                          style: themeProvider.obterTema().brightness ==
                                  Brightness.dark
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
                          style: themeProvider.obterTema().brightness ==
                                  Brightness.dark
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AporteScreen(),
                        ),
                      );
                    },
                    child: Column(
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
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SaqueScreen(),
                            ),
                          );
                        },
                        child: Container(
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
                      GestureDetector(
                        onTap: () {},
                        child: Container(
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
              Consumer<RecadoProvider>(
                builder: (context, recadoProvider, _) {
                  return recadoProvider.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : SizedBox(
                          height: 80,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: recadoProvider.recados.length,
                            itemBuilder: (context, index) {
                              return CarouselSlider(
                                items: recadosProvider.recados.map((r) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .dividerColor),
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Text(
                                          r.recado,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                  viewportFraction: 0.6,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 5),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 2500),
                                  enlargeCenterPage: false,
                                ),
                              );
                            },
                            pageSnapping: true,
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
