import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/Cliente.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key, required this.listaDeSaldos});
  final List<Saldo> listaDeSaldos;

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {

    //print('\n\n ${widget.listaDeSaldos.map((e) => e.valor)} \n\n');
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 0,
              left: 0,
              top: 0,
              bottom: 0,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        widget.listaDeSaldos[value.toInt()].data, // Extrai o mês da data
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).indicatorColor,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String formattedValue = (value * 1000).toInt().toString(); // Converte para milhares e transforma em string
    if (formattedValue.length > 3) {
      // Se o valor tiver mais de três dígitos, adicione "mil" após os primeiros dígitos
      formattedValue = "${formattedValue.substring(0, formattedValue.length - 3)}mil";
    }
    return Text(
      formattedValue,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).indicatorColor,
        fontSize: 10,
      ),
      textAlign: TextAlign.left,
    );
  }

  LineChartData mainData() {
    List<FlSpot> spots = [];
    for (int i = 0; i < widget.listaDeSaldos.length; i++) {
      spots.add(FlSpot(i.toDouble(), widget.listaDeSaldos[i].valor / 1000)); // Converte para milhares
    }

    double maxSaldo = 0;
    for (Saldo saldo in widget.listaDeSaldos) {
      if (saldo.valor > maxSaldo) {
        maxSaldo = saldo.valor.toDouble();
      }
    }

    double minSaldo = widget.listaDeSaldos.isNotEmpty ? widget.listaDeSaldos[0].valor.toDouble() : 0;
    for (Saldo saldo in widget.listaDeSaldos) {
      if (saldo.valor < minSaldo) {
        minSaldo = saldo.valor.toDouble();
      }
    }

    List<Color> gradientColors = [
      Theme.of(context).primaryColor,
      Theme.of(context).primaryColor,
    ];

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: false,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color:Theme.of(context).indicatorColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Theme.of(context).indicatorColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            //interval: 10,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: widget.listaDeSaldos.length.toDouble() - 1, // Atualiza o valor máximo do eixo x
      minY: minSaldo / 1000,
      maxY: maxSaldo / 1000, // Pode ser ajustado conforme necessário
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}