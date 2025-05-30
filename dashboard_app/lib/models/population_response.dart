import 'population_data.dart';

class PopulationResponse {
  final List<PopulationData> data;
  PopulationResponse({required this.data});
  factory PopulationResponse.fromJson(Map<String, dynamic> json) {
    var dataJsonList = json['data'] as List<dynamic>? ?? [];
    List<PopulationData> dataList = dataJsonList.map((item) {
      return PopulationData.fromJson(item as Map<String, dynamic>);
    }).toList();
    return PopulationResponse(data: dataList);
  }
}
