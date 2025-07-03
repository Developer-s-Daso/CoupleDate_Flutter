import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiAIService {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? 'YOUR_GEMINI_API_KEY';
  final String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  Future<String> recommendPlaces({
    required String location,
    required String preference,
    required String mood,
    required String budget,
    required String time,
  }) async {
    final prompt =
        '내 위치는 $location, 선호 카테고리는 $preference, 분위기는 $mood, 예산은 $budget, 시간대는 $time야. 이런 조건에 맞는 데이트 장소를 3곳 추천해줘. 각 장소는 한 줄 설명과 함께 알려줘.';
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ]
    });
    final useMock = dotenv.env['USE_MOCK'] == 'true';
    if (useMock) {
      // Mock AI 추천 결과 (USE_MOCK=true)
      return '''
1. 디버그 카페 - 분위기 좋은 커플 카페
2. 테스트 레스토랑 - 합리적 가격의 맛집
3. 모의 공원 - 산책하기 좋은 공원
''';
    }
    final response = await http.post(
      Uri.parse('$_baseUrl?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? '추천 결과 없음';
      return text;
    } else {
      throw Exception('Gemini AI API error: ${response.statusCode}');
    }
  }
}
