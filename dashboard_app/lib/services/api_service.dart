import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/population_data.dart'; 

class ApiService {
  final http.Client client;
  ApiService({http.Client? client}) : client = client ?? http.Client();
  static const String populationUrl =
      'https://datausa.io/api/data?drilldowns=Nation&measures=Population';
  Future<PopulationResponse> fetchPopulationData() async {
    final response = await client.get(Uri.parse(populationUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return PopulationResponse.fromJson(json);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
