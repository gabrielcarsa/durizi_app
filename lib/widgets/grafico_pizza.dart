import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class GraficoPizza extends StatefulWidget {
  const GraficoPizza(
      {super.key, required this.totalInvestido, required this.totalJuros});

  final double totalJuros;
  final double totalInvestido;

  @override
  State<StatefulWidget> createState() => GraficoPizzaState();
}

class GraficoPizzaState extends State<GraficoPizza> {
  int touchedIndex = -1;
  double valorSomadoTotal = 0;
  double porcentagemTotalJuros = 0;
  double porcentagemTotalInvestido = 0;

  @override
  void initState() {
    super.initState();
    valorSomadoTotal = widget.totalJuros + widget.totalInvestido;
    porcentagemTotalJuros = (widget.totalJuros * 100) / valorSomadoTotal;
    porcentagemTotalInvestido =
        (widget.totalInvestido * 100) / valorSomadoTotal;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Row(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Indicator(
                color: Theme.of(context).primaryColor,
                text: 'Valor investido',
                isSquare: true,
              ),
              const SizedBox(
                height: 4,
              ),
              const Indicator(
                color: Colors.green,
                text: 'Valor juros',
                isSquare: true,
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
          const SizedBox(
            width: 28,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.green,
            value: porcentagemTotalJuros,
            title: '${double.parse(porcentagemTotalJuros.toStringAsFixed(1))}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Theme.of(context).primaryColor,
            value: porcentagemTotalInvestido,
            title: '${double.parse(porcentagemTotalInvestido.toStringAsFixed(1))}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
