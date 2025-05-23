import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/population_data.dart';
import '../services/api_service.dart';
final populationProvider = FutureProvider<List<PopulationData>>((ref) async {
  final response = await ApiService.fetchPopulationData();
  if (response != null) {
    return response.data;
  } else {
    throw Exception('Failed to fetch population data');
  }
});