// lib/widgets/population_chart_container.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/population_data.dart';
import '../providers/population_provider.dart';
import 'population_chart.dart';

class PopulationChartContainer extends ConsumerWidget {
  const PopulationChartContainer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPopulation = ref.watch(populationProvider);
    return asyncPopulation.when(
      data: (data) {
        if (data.isEmpty) {
          return const Center(
            child: Text('No population data available.'),
          );
        }
        return PopulationChart(data: data);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Error loading population data:\n${error.toString()}',
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
