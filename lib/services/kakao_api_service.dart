
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KakaoApiService {
  final String _baseUrl = 'https://dapi.kakao.com/v2/local/search/keyword.json';

  Future<List<dynamic>> searchPlaces(String query, {double? x, double? y}) async {
    final apiKey = const String.fromEnvironment('KAKAO_REST_API_KEY', defaultValue: '') != ''
        ? const String.fromEnvironment('KAKAO_REST_API_KEY')
        : (dotenv.env['KAKAO_REST_API_KEY'] ?? '');
    final useMock = dotenv.env['USE_MOCK'] == 'true';
    if (useMock) {
      // Mock data for debugging when USE_MOCK is true
      return [
        {
          'id': 'mock1',
          'place_name': '디버그 카페',
          'y': '37.5665',
          'x': '126.9780',
          'road_address_name': '서울특별시 중구 세종대로 110',
          'category_name': '카페',
          'phone': '02-0000-0000',
        },
        {
          'id': 'mock2',
          'place_name': '테스트 맛집',
          'y': '37.5651',
          'x': '126.9895',
          'road_address_name': '서울특별시 종로구 종로 1',
          'category_name': '맛집',
          'phone': '02-1111-1111',
        },
      ];
    }
    final headers = {'Authorization': 'KakaoAK $apiKey'};
    final params = {
      'query': query,
      if (x != null && y != null) ...{
        'x': x.toString(),
        'y': y.toString(),
        'radius': '2000',
      },
      'size': '20',
    };
    final uri = Uri.parse(_baseUrl).replace(queryParameters: params);
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['documents'];
    } else {
      throw Exception('Kakao API error: ${response.statusCode}');
    }
  }
}
