import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AICounselorService {
  late final GenerativeModel _model;

  AICounselorService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Gemini API 키가 .env 파일에 설정되어 있지 않습니다.');
    }
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
    );
  }

  /// 대화 전체 메시지(역할, 내용 포함)를 받아 심리상담 챗봇 답변을 반환합니다.
  Future<String> chatWithHistory(List<Map<String, String>> messages) async {
    // 항상 실제 Gemini API를 사용하도록 mock 분기 제거
    const systemPrompt = '''
너는 따뜻하고 공감 능력이 뛰어난 심리상담 전문가야. 특히 연인/커플의 고민, 감정, 갈등, 연애 문제에 대해 진심으로 공감하고, 친절하고 전문적으로 상담해줘. 항상 상대방의 감정을 존중하고, 위로와 응원, 실질적인 조언을 함께 제공해. 절대 판단하거나 비난하지 말고, 언제나 따뜻한 말투로 대답해. 상담은 반드시 한국어로 해줘.
''';

    // 대화 이력 + system prompt 결합
    final List<Content> contentList = [Content.text(systemPrompt)];
    for (final msg in messages) {
      final text = msg['content'] ?? '';
      if (text.isNotEmpty) {
        if (msg['role'] == 'user') {
          contentList.add(Content.text(text));
        }
        // Gemini API는 model의 답변을 대화 이력에 넣지 않아도 됨
      }
    }
    try {
      final response = await _model.generateContent(contentList);
      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      } else {
        return '상담 결과가 없습니다. 다시 시도해 주세요.';
      }
    } catch (e) {
      return 'AI 상담 중 오류가 발생했습니다: ${e.toString()}';
    }
  }
}