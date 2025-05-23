class PopulationResponse {
  final List<PopulationData> data;
  PopulationResponse({required this.data});
  factory PopulationResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>;
    return PopulationResponse(
      data: dataList.map((item) => PopulationData.fromJson(item)).toList(),
    );
  }
}
class PopulationData {
  final String nation;
  final String idNation;
  final String year;
  final int idYear;
  final int population;
  final String slugNation;
  PopulationData({
    required this.nation,
    required this.idNation,
    required this.year,
    required this.idYear,
    required this.population,
    required this.slugNation,
  });
  factory PopulationData.fromJson(Map<String, dynamic> json) {
    return PopulationData(
      nation: json['Nation'] as String,
      idNation: json['ID Nation'] as String,
      year: json['Year'] as String,
      idYear: json['ID Year'] as int,
      population: json['Population'] as int,
      slugNation: json['Slug Nation'] as String,
    );
  }
}