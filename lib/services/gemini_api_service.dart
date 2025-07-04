import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class GeminiApiService {
  late final GenerativeModel _model;

  GeminiApiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY가 .env 파일에 설정되지 않았습니다.');
    }
    _model = GenerativeModel(
      model: 'gemini-2.0-flash', // 또는 'gemini-2.0-flash-exp'
      apiKey: apiKey,
    );
  }

  Future<String> getCounselingReply(List<Map<String, String>> messages) async {
    try {
      final prompt = messages.map((m) => m['content']).join('\n');
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      } else {
        return '죄송합니다. 응답을 생성할 수 없습니다.';
      }
    } catch (e) {
      if (kDebugMode) print('Gemini API 오류: $e');
      if (e.toString().contains('API_KEY_INVALID')) {
        return '오류: API 키가 올바르지 않습니다. .env 파일의 GEMINI_API_KEY를 확인해주세요.';
      } else if (e.toString().contains('QUOTA_EXCEEDED')) {
        return '오류: API 사용량 한도를 초과했습니다.';
      } else if (e.toString().contains('model')) {
        return '오류: 모델을 찾을 수 없습니다. 다시 시도해주세요.';
      } else {
        return '오류가 발생했습니다: $e';
      }
    }
  }
}
