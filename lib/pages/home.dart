import 'package:carousel_slider/carousel_slider.dart';
import 'package:durizi_app/pages/aporteScreen.dart';
import 'package:durizi_app/pages/contratoScreen.dart';
import 'package:durizi_app/pages/saqueScreen.dart';
import 'package:durizi_app/pages/sobreScreen.dart';
import 'package:durizi_app/providers/RecadoProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/Cliente.dart';
import '../providers/ClienteProvider.dart';
import '../providers/StockProvider.dart';
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

    //Atualizar saldo
    clienteProvider.atualizarSaldoDiario(clienteProvider.clienteAtual!);

    super.initState();

    // Variável para obter o mês e ano da data de hoje
    DateTime agora = DateTime.now();
    DateTime dozeMesesAtras = agora.subtract(const Duration(days: 365));

    // Formato da data
    DateFormat formatadorData = DateFormat('dd/MM/yyyy');

    // Map para armazenar o saldo mais recente de cada mês
    Map<String, Saldo> saldosPorMes = {};

    if (clienteProvider.clienteAtual?.saldo != null) {
      for (Saldo saldo in clienteProvider.clienteAtual!.saldo!) {
        try {
          DateTime dataSaldo = formatadorData.parse(saldo.data);
          // Usar o ano e o mês como chave para o agrupamento
          String chaveMesAno = DateFormat('MM/yyyy').format(dataSaldo);

          // Adicionar ou atualizar o saldo mais recente para cada mês
          if (dataSaldo.isAfter(dozeMesesAtras)) {
            if (!saldosPorMes.containsKey(chaveMesAno) ||
                dataSaldo.isAfter(
                    formatadorData.parse(saldosPorMes[chaveMesAno]!.data))) {
              saldosPorMes[chaveMesAno] = saldo;
            }
          }
        } catch (e) {
          //print('Erro ao analisar a data: $e');
        }
      }

      // Converter o mapa em uma lista e ordenar por data (ordem crescente)
      saldosMesesDiferentes = saldosPorMes.values.toList()
        ..sort((a, b) => formatadorData
            .parse(a.data)
            .compareTo(formatadorData.parse(b.data)));
    }
  }

  @override
  Widget build(BuildContext context) {
    //Providers
    final themeProvider = Provider.of<TipoTemaProvider>(context);
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
    Provider.of<StockProvider>(context, listen: false)
        .getStock(); // Use o símbolo desejado aqui
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      endDrawer: Drawer(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
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
                              style: Theme.of(context).textTheme.bodyLarge,
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
                    themeProvider.obterTema().brightness == Brightness.dark
                        ? 'Alterar para modo claro'
                        : 'Alterar para modo escuro',
                    style: Theme.of(context).textTheme.bodyLarge,
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
                    style: Theme.of(context).textTheme.bodyLarge,
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
        iconTheme: IconThemeData(
          color: Theme.of(context).indicatorColor,
        ),
        toolbarHeight: 80,
        elevation: 0,
        title: themeProvider.obterTema().brightness == Brightness.dark
            ? Container(
                height: 100.0,
                width: 100.0,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/logo-em-branco.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              )
            : Container(
                height: 100.0,
                width: 100.0,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/logo_light.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
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
                saldosMesesDiferentes.isEmpty
                    ? 'R\$ 0'
                    : formatadorMoeda.format(saldosMesesDiferentes.last.valor),
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w700,
                  color: themeProvider.obterTema().brightness == Brightness.dark
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFF000000),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: MediaQuery.of(context).size.width < 576 ? 2 : 3,
                      child: LineChartSample2(
                          listaDeSaldos: saldosMesesDiferentes),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '+ ${formatadorMoeda.format(diferenca)}',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width < 576
                                  ? 14
                                  : 16,
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
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width < 576
                                  ? 14
                                  : 16,
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
                    ),
                  ],
                ),
              ),
              Text(
                'Ações',
                style: Theme.of(context).textTheme.bodyLarge,
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
                            color: Theme.of(context).secondaryHeaderColor,
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
                            color: Theme.of(context).secondaryHeaderColor,
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
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContratoScreen(
                                cliente: clienteAtual,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).secondaryHeaderColor,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SobreScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).secondaryHeaderColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            size: 40,
                            color: Theme.of(context).primaryColor,
                          ),
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
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 5.0,
              ),
              Consumer<RecadoProvider>(
                builder: (context, recadoProvider, _) {
                  // Filtrando apenas os recados ativos
                  final activeRecados = recadoProvider.recados
                      .where((r) => r.isAtivo == true)
                      .toList();
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
                            itemCount: activeRecados.length,
                            itemBuilder: (context, index) {
                              return CarouselSlider(
                                items: activeRecados.map((r) {
                                  return Builder(
                                      builder: (BuildContext context) {
                                    return Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.8,
                                      padding: const EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Theme.of(context).dividerColor),
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Text(
                                        r.recado,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    );
                                  });
                                }).toList(),
                                options: CarouselOptions(
                                  enableInfiniteScroll: false,
                                  viewportFraction: 0.8,
                                  autoPlay: /*qtdRecados > 1 ? true : */ false,
                                  autoPlayInterval: const Duration(seconds: 5),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 2500),
                                  enlargeCenterPage: true,
                                ),
                              );
                            },
                            pageSnapping: true,
                          ),
                        );
                },
              ),
              const SizedBox(
                height: 15.0,
              ),
              Text(
                'Principais cotações',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 5.0,
              ),
              SizedBox(
                height: 200.0, // Defina a altura desejada
                child: Consumer<StockProvider>(
                  builder: (context, stockProvider, child) {
                    if (stockProvider.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (stockProvider.errorMessage != null) {
                      return Center(child: Text(stockProvider.errorMessage!));
                    }

                    return ListView.builder(
                      itemCount: stockProvider.stocks.length,
                      itemBuilder: (context, index) {
                        final stock = stockProvider.stocks[index];
                        return ListTile(
                          leading: stock.logourl.isNotEmpty
                              ? SvgPicture.network(
                                  stock.logourl,
                                )
                              : null,
                          title: Text(
                            stock.symbol,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          subtitle: Text(
                            formatadorMoeda.format(stock.regularMarketPrice),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: Text(
                            '${stock.regularMarketChangePercent.toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: stock.regularMarketChangePercent >= 0
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 15,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
