import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/population_data.dart';

class PopulationChart extends StatelessWidget {
  final List<PopulationData> data;
  const PopulationChart({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    final sortedData = data..sort((a, b) => a.year.compareTo(b.year));
    final spots = sortedData.map((e) {
      return FlSpot(
        double.tryParse(e.year) ?? 0,
        e.population.toDouble(),
      );
    }).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 100.0, 90.0, 16.0), 
      child: LineChart(
        LineChartData(
          backgroundColor: Colors.white,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              axisNameWidget: const Text('Year'),
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, _) {
                  return Text(value.toInt().toString(),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ));
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text('Population'),
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20000000,
                reservedSize: 60,
                getTitlesWidget: (value, _) {
      return Text(
        '${(value / 1000000).toStringAsFixed(0)}M',
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
      },
      ),
      ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.deepPurple, width: 2),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: const LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
              ),
              barWidth: 4,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.withOpacity(0.3),
                    Colors.purple.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.deepPurple,
                    strokeColor: Colors.white,
                    strokeWidth: 2,
                  );
                },
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipPadding: const EdgeInsets.all(8),
              tooltipMargin: 16,
              tooltipBorder: BorderSide(color: Colors.white, width: 2),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    'Year: ${spot.x.toInt()}\nPopulation: ${spot.y.toInt()}',
                    const TextStyle(color: Colors.white),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}