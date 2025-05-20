import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';
import 'models.dart';

final populationProvider = FutureProvider<List<PopulationData>>((ref) async {
  final response = await ApiService.fetchPopulationData();
  if (response != null) {
    return response.data;
  } else {
    throw Exception('Failed to fetch population data');
  }
});
void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  final Color customColor = const Color.fromARGB(255, 233, 222, 255);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Population Dashboard',
      theme: ThemeData(
        primaryColor: customColor,
        appBarTheme: AppBarTheme(
          backgroundColor: customColor,
          foregroundColor: Colors.black,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: customColor,
          foregroundColor: Colors.black,
        ),
      ),
      home: PopulationScreen(),
    );
  }
}
class PopulationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final populationAsyncValue = ref.watch(populationProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Population Data')),
      body: populationAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (populationList) {
          return ListView.builder(
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