class PopulationData {
  final String idNation;
  final String nation;
  final int idYear;
  final String year;
  final int population;
  final String slugNation;
  PopulationData({
    required this.idNation,
    required this.nation,
    required this.idYear,
    required this.year,
    required this.population,
    required this.slugNation,
  });
  factory PopulationData.fromJson(Map<String, dynamic> json) {
    return PopulationData(
      idNation: json['ID Nation'] as String,
      nation: json['Nation'] as String,
      idYear: json['ID Year'] as int,
      year: json['Year'] as String,
      population: json['Population'] as int,
      slugNation: json['Slug Nation'] as String,
    );
  }
}
class PopulationResponse {
  final List<PopulationData> data;
  PopulationResponse({required this.data});
  factory PopulationResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List<dynamic>;
    List<PopulationData> populationList = list.map((item) => PopulationData.fromJson(item)).toList();
    return PopulationResponse(data: populationList);
  }
}