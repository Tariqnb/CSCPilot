import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/population_provider.dart';
import '../widgets/population_chart.dart';

class PopulationScreen extends ConsumerWidget {
  const PopulationScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final populationAsyncValue = ref.watch(populationProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Population Data')),
        backgroundColor: Colors.white,
        body: populationAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (populationList) {
          return Column(
            children: [
              SizedBox(
                height: 300,
                child: PopulationChart(data: populationList),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: populationList.length,
                  itemBuilder: (context, index) {
                    final item = populationList[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text('${item.nation} (${item.year})'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID Nation: ${item.idNation}'),
                            Text('ID Year: ${item.idYear}'),
                            Text('Population: ${item.population}'),
                            Text('Slug Nation: ${item.slugNation}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.refresh(populationProvider),
        child: const Icon(Icons.refresh),
        tooltip: 'Refresh Data',
      ),
    );
  }
}