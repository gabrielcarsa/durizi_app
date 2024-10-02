import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/TipoTemaProvider.dart';

class SimulacaoInvestimento extends StatefulWidget {
  const SimulacaoInvestimento({super.key});

  @override
  State<SimulacaoInvestimento> createState() => _SimulacaoInvestimentoState();
}

class _SimulacaoInvestimentoState extends State<SimulacaoInvestimento> {
  // Para formatar em número
  final NumberFormat formatadorMoeda =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  //controller
  final TextEditingController _valorController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final TextEditingController _valorMensalController =
      MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  final TextEditingController _taxaJurosController = TextEditingController();
  final TextEditingController _periodoMeses = TextEditingController();

  //form
  final _formKey = GlobalKey<FormState>();

  //variavel controle de tela
  bool _telaResultado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        foregroundColor: Theme.of(context).indicatorColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Simular Investimento',
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
      body: !_telaResultado ? buildFormScreen() : buildResultScreen(),
    );
  }

  // Tela de formulário
  Widget buildFormScreen() {
    final themeProvider = Provider.of<TipoTemaProvider>(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Nossa calculadora de juros compostos',
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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Valor inicial (R\$)',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextFormField(
                controller: _valorController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  filled: true,
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
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Valor mensal (R\$)',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextFormField(
                controller: _valorMensalController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  filled: true,
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
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Taxa de juros (% ao mês)',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextFormField(
                controller: _taxaJurosController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Ex.: 3',
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
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Período em meses',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextFormField(
                controller: _periodoMeses,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Ex.: 24',
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
                    setState(() {
                      _telaResultado = true;
                    });
                  }
                },
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 5),
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  backgroundColor:
                      WidgetStateProperty.all(Theme.of(context).primaryColor),
                ),
                child: Text(
                  'Simular Investimento',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Tela de resultados
  Widget buildResultScreen() {
    //Valores Campos
    String valorInicialFormatado =
        _valorController.text.replaceAll('.', '').replaceAll(',', '.');

    String valorMensalFormatado =
        _valorMensalController.text.replaceAll('.', '').replaceAll(',', '.');

    String taxaJurosMensalFormatado = _taxaJurosController.text;
    String periodoMesesFormatado = _periodoMeses.text;

    //Convertendo para double
    double valorInicial = double.parse(valorInicialFormatado);
    double valorMensal = double.parse(valorMensalFormatado);
    int periodoMeses = int.parse(periodoMesesFormatado);
    double taxaJurosMensal = double.parse(taxaJurosMensalFormatado);
    taxaJurosMensal = taxaJurosMensal / 100;

    // Função para calcular o montante com aportes mensais
    double calcularMontante(
        double valorInicial, double valorMensal, double taxa, int meses) {
      return valorInicial * pow(1 + taxa, meses) +
          valorMensal * ((pow(1 + taxa, meses) - 1) / taxa);
    }

    // Valores
    double valorMontante = calcularMontante(
        valorInicial, valorMensal, taxaJurosMensal, periodoMeses);
    double valorInvestidoTotal = valorInicial + (valorMensal * periodoMeses);
    double valorJurosTotal = valorMontante - valorInvestidoTotal;

    final themeProvider = Provider.of<TipoTemaProvider>(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Investindo inicialmente ${formatadorMoeda.format(double.parse(valorInicialFormatado))} você obterá:',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.6),
                        Theme.of(context).primaryColor.withOpacity(0.3),
                      ],
                      begin: AlignmentDirectional.topStart,
                      end: AlignmentDirectional.bottomEnd,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      width: 1.5,
                      color: Theme.of(context).indicatorColor.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Período',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Total investido',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              periodoMeses > 1
                                  ? '$periodoMesesFormatado meses'
                                  : '$periodoMesesFormatado mês',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              formatadorMoeda.format(valorInvestidoTotal),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Taxa de juros (%)',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Total de juros',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              '$taxaJurosMensalFormatado%',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              formatadorMoeda.format(valorJurosTotal),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Valor mensal',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Valor inicial',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              formatadorMoeda.format(valorMensal),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              formatadorMoeda.format(valorInicial),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Valor total final',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formatadorMoeda.format(valorMontante),
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _valorController.clear();
                  _telaResultado = false;
                });
              },
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 5),
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                backgroundColor:
                    WidgetStateProperty.all(Theme.of(context).indicatorColor),
              ),
              child: Text(
                'Simular outro valor',
                style: TextStyle(
                  fontSize: 16.0,
                  color: themeProvider.obterTema().brightness == Brightness.dark
                      ? const Color(0xFF5964FB)
                      : const Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
