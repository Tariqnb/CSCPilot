import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/population_data.dart';

class ApiService {
  static const String apiUrl = 'https://datausa.io/api/data?drilldowns=Nation&measures=Population';
  static Future<PopulationResponse?> fetchPopulationData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return PopulationResponse.fromJson(json);
      } else {
        print('Failed to load data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching population data: $e');
      return null;
    }
  }
}