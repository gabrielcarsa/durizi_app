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
                'Vamos dar os primeiros passos, quanto você deseja investir inicialmente?',
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
              child: TextFormField(
                controller: _valorController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Quanto você deseja investir?',
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
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 5),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
                child: Text(
                  'Simular Investimento',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      '*A simulação não leva em consideração aportes regulares. Para saber mais fale conosco.',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Tela de resultados
  Widget buildResultScreen() {
    String valorFormatado =
        _valorController.text.replaceAll('.', '').replaceAll(',', '.');
    //valores da simulação
    double valorInicial = double.parse(valorFormatado);
    double valor1Meses = (valorInicial * 0.03);
    double valor3Meses = (valorInicial * pow(1 + 0.03, 3)) - valorInicial;
    double valor6Meses = (valorInicial * pow(1 + 0.03, 6)) - valorInicial;
    double valor9Meses = (valorInicial * pow(1 + 0.03, 9)) - valorInicial;
    double valor12Meses = (valorInicial * pow(1 + 0.03, 12)) - valorInicial;
    double valor18Meses = (valorInicial * pow(1 + 0.03, 18)) - valorInicial;
    double valor24Meses = (valorInicial * pow(1 + 0.03, 24)) - valorInicial;

    final themeProvider = Provider.of<TipoTemaProvider>(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              'Investindo ${formatadorMoeda.format(double.parse(valorFormatado))}\n você obterá:',
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
                            flex: 2,
                            child: Text(
                              'Período',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Rendimento',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.displaySmall,
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
                            flex: 2,
                            child: Text(
                              'em 1 mês',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              formatadorMoeda.format(valor1Meses),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'em 3 meses',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              formatadorMoeda.format(valor3Meses),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'em 6 meses',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              formatadorMoeda.format(valor6Meses),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'em 9 meses',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              formatadorMoeda.format(valor9Meses),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'em 1 ano',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              formatadorMoeda.format(valor12Meses),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'em 1 e 6 meses',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              formatadorMoeda.format(valor18Meses),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'em 2 anos',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              formatadorMoeda.format(valor24Meses),
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
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
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 5),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).indicatorColor),
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
