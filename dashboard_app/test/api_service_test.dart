import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:dashboard_app/services/api_service.dart';
import 'package:dashboard_app/models/population_data.dart';
import 'mocks.mocks.dart';

void main() {
  late MockClient mockClient;
  late ApiService apiService;
  setUp(() {
    mockClient = MockClient();
    apiService = ApiService(client: mockClient);
  });
  test('fetchPopulationData returns PopulationResponse on 200 OK', () async {
    const mockJson = '''
    {
      "data": [
        {
          "ID Nation": "01000US",
          "Nation": "United States",
          "ID Year": 2020,
          "Year": "2020",
          "Population": 326569308,
          "Slug Nation": "united-states"
        }
      ]
    }
    ''';
    when(mockClient.get(Uri.parse(ApiService.populationUrl)))
        .thenAnswer((_) async => http.Response(mockJson, 200));
    final result = await apiService.fetchPopulationData();
    expect(result.data, isNotEmpty);
    expect(result.data.first.nation, equals("United States"));
  });
  test('fetchPopulationData throws Exception on non-200 status code', () async {
    when(mockClient.get(Uri.parse(ApiService.populationUrl)))
        .thenAnswer((_) async => http.Response('Error', 404));
    expect(() => apiService.fetchPopulationData(), throwsException);
  });
  test('fetchPopulationData throws Exception on invalid JSON response', () async {
    when(mockClient.get(Uri.parse(ApiService.populationUrl)))
        .thenAnswer((_) async => http.Response('Invalid JSON', 200));
    expect(() => apiService.fetchPopulationData(), throwsException);
  });
  test('fetchPopulationData throws Exception on network failure', () async {
    when(mockClient.get(Uri.parse(ApiService.populationUrl)))
        .thenThrow(Exception('No internet connection'));
    expect(() => apiService.fetchPopulationData(), throwsException);
  });
}
