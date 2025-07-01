import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart' as graphic;
import 'package:pie_chart/pie_chart.dart' as pie;
import '../models/population_data.dart';

class PopulationChart extends StatefulWidget {
  final List<PopulationData> data;
  const PopulationChart({super.key, required this.data});
  @override
  State<PopulationChart> createState() => _PopulationChartState();
}

class _PopulationChartState extends State<PopulationChart> {
  String? selectedMinYear;
  String? selectedMaxYear;
  @override
  Widget build(BuildContext context) {
    final years = widget.data.map((e) => e.year).toSet().toList()..sort();
    final minYear = selectedMinYear != null ? int.tryParse(selectedMinYear!) : null;
    final maxYear = selectedMaxYear != null ? int.tryParse(selectedMaxYear!) : null;
    final filteredData = widget.data.where((e) {
      final yearInt = int.tryParse(e.year) ?? 0;
      if (minYear != null && maxYear != null) {
        return yearInt >= minYear && yearInt <= maxYear;
      } else if (minYear != null) {
        return yearInt >= minYear;
      } else if (maxYear != null) {
        return yearInt <= maxYear;
      }
      return true;
    }).toList();
    final chartData = filteredData
        .map((e) => {
              'year': int.tryParse(e.year),
              'population': e.population,
            })
        .where((e) => e['year'] != null)
        .toList()
      ..sort((a, b) => a['year']!.compareTo(b['year']!));
    final donutData = chartData.where((e) {
      final year = e['year'] as int;
      return year >= 2013 && year <= 2023;
    }).toList();
    final spots = chartData
        .map((e) => FlSpot(
              (e['year'] as int).toDouble(),
              (e['population'] as int).toDouble(),
            ))
        .toList();
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(' ', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    DropdownButton<String>(
                      value: selectedMinYear,
                      hint: const Text('Min Year'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('No Min')),
                        ...years.map((year) => DropdownMenuItem(
                              value: year,
                              child: Text(year),
                            )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedMinYear = value;
                          if (selectedMaxYear != null &&
                              int.tryParse(selectedMaxYear!) != null &&
                              int.tryParse(value ?? '') != null) {
                            final minVal = int.tryParse(value!)!;
                            final maxVal = int.tryParse(selectedMaxYear!)!;
                            if (minVal > maxVal) selectedMaxYear = value;
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 20),
                    DropdownButton<String>(
                      value: selectedMaxYear,
                      hint: const Text('Max Year'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('No Max')),
                        ...years.map((year) => DropdownMenuItem(
                              value: year,
                              child: Text(year),
                            )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedMaxYear = value;
                          if (selectedMinYear != null &&
                              int.tryParse(selectedMinYear!) != null &&
                              int.tryParse(value ?? '') != null) {
                            final minVal = int.tryParse(selectedMinYear!)!;
                            final maxVal = int.tryParse(value!)!;
                            if (maxVal < minVal) selectedMinYear = value;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (spots.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'No data available for the selected year range.',
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            )
          else ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 20.0, 90.0, 16.0),
              child: SizedBox(
                height: 200,
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
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
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
              ),
            ),
            const SizedBox(height: 32),
            const Divider(height: 2, color: Colors.grey),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.fromLTRB(100.0, 0.0, 90.0, 100.0),
              child: SizedBox(
                height: 300,
                child: graphic.Chart(
                  data: chartData,
                  variables: {
                    'year': graphic.Variable(
                      accessor: (Map map) => map['year'] as int,
                      scale: graphic.LinearScale(tickCount: 5),
                    ),
                    'population': graphic.Variable(
                      accessor: (Map map) => map['population'] as int,
                      scale: graphic.LinearScale(),
                    ),
                  },
                  marks: [
                    graphic.LineMark(
                      position: graphic.Varset('year') * graphic.Varset('population'),
                      shape: graphic.ShapeEncode(value: graphic.BasicLineShape(smooth: true)),
                      color: graphic.ColorEncode(value: Colors.deepPurple),
                      size: graphic.SizeEncode(value: 3),
                    ),
                    graphic.PointMark(
                      position: graphic.Varset('year') * graphic.Varset('population'),
                      size: graphic.SizeEncode(value: 5),
                      color: graphic.ColorEncode(value: Colors.purpleAccent),
                    ),
                  ],
                  axes: [
                    graphic.Defaults.horizontalAxis,
                    graphic.Defaults.verticalAxis,
                  ],
                  selections: {
                    'tap': graphic.PointSelection(on: {graphic.GestureType.tap}),
                  },
                  tooltip: graphic.TooltipGuide(
                    selections: {'tap'},
                    variables: ['year', 'population'],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Divider(height: 2, color: Colors.grey),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 310,
                width: double.infinity,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.center,
                    groupsSpace: 6,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipPadding: const EdgeInsets.all(10),
                        tooltipMargin: 10,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final year = chartData[groupIndex]['year'];
                          final population = chartData[groupIndex]['population'];
                          return BarTooltipItem(
                            'Year: $year\nPopulation: ${((population ?? 0) / 1000000).toStringAsFixed(1)}M',
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        axisNameWidget: const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          getTitlesWidget: (value, _) {
                            final index = value.toInt();
                            if (index >= 0 && index < chartData.length) {
                              final year = chartData[index]['year'];
                              return Text(
                                year.toString(),
                                style: const TextStyle(fontSize: 11),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        axisNameWidget: const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          interval: 20000000,
                          getTitlesWidget: (value, _) {
                            return Text(
                              '${(value / 1000000).toStringAsFixed(0)}M',
                              style: const TextStyle(fontSize: 11),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: 20000000,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: const Border(
                        left: BorderSide(color: Colors.black, width: 1),
                        bottom: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    barGroups: List.generate(chartData.length, (index) {
                      final population = chartData[index]['population'];
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: (population as int).toDouble(),
                            width: 50,
                            color: Colors.deepPurple.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Divider(height: 2, color: Colors.grey),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  pie.PieChart(
                    dataMap: {
                      for (var e in donutData)
                        e['year'].toString(): (e['population'] as int).toDouble(),
                    },
                    animationDuration: const Duration(milliseconds: 800),
                    chartType: pie.ChartType.ring,
                    chartRadius: MediaQuery.of(context).size.width / 2.2,
                    colorList: [
                        Colors.deepPurple,
                        Colors.teal,
                        Colors.amber,
                        Colors.indigo,
                        Colors.orange,
                        Colors.pink,
                        Colors.cyan,
                        Colors.lime,
                        Colors.brown,
                        Colors.blueGrey,
                        Colors.green,
                      ],                    
                    ringStrokeWidth: 32,
                    legendOptions: const pie.LegendOptions(
                      showLegends: true,
                      legendPosition: pie.LegendPosition.right,
                    ),
                    chartValuesOptions: const pie.ChartValuesOptions(
                      showChartValuesInPercentage: false,
                      showChartValues: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
