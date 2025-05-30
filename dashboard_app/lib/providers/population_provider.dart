import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/population_data.dart';
import 'api_service_provider.dart';

final populationProvider = FutureProvider<List<PopulationData>>((ref) async {
  final apiService = ref.watch(apiServiceProvider); 
  final response = await apiService.fetchPopulationData(); 
  return response.data; 
});
