import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/population_chart_container.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Population Data App',
      home: Scaffold(
        appBar: AppBar(title: Text('Population Chart')),
        body: PopulationChartContainer(), 
      ),
    );
  }
}
