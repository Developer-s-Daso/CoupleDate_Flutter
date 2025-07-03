import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_question.dart';
import 'gemini_api_service.dart';

/// 1일 1문(커플 질문) 서비스
class DailyQuestionService {
  static const _storageKey = 'daily_questions';
  final GeminiApiService _geminiApi = GeminiApiService();

  /// 오늘 날짜(yyyy-MM-dd)로 저장된 DailyQuestion을 불러옴
  Future<DailyQuestion?> loadTodayQuestion() async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = _todayKey();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr == null) return null;
    final Map<String, dynamic> all = jsonDecode(jsonStr);
    if (!all.containsKey(todayKey)) return null;
    return DailyQuestion.fromJson(all[todayKey]);
  }

  /// 오늘 날짜에 대한 DailyQuestion을 저장
  Future<void> saveTodayQuestion(DailyQuestion question) async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = _todayKey();
    Map<String, dynamic> all = {};
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr != null) {
      all = jsonDecode(jsonStr);
    }
    all[todayKey] = question.toJson();
    await prefs.setString(_storageKey, jsonEncode(all));
  }

  /// Gemini API로 오늘의 커플 질문 생성
  Future<String> generateTodayQuestion() async {
    // 프롬프트는 커플 관련, 따뜻하고 대화 유도하는 질문으로 요청
    const prompt = '연인끼리 하루에 한 번 서로에게 답하면 좋은, 따뜻하고 대화가 이어질 수 있는 질문을 한 문장으로 한국어로 만들어줘.';
    final reply = await _geminiApi.getCounselingReply([
      {'role': 'user', 'content': prompt},
    ]);
    return reply.trim();
  }

  /// 오늘 날짜(yyyy-MM-dd) 키 반환
  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// 오늘 답변 저장 (질문은 그대로, answer만 갱신)
  Future<void> saveTodayAnswer(String answer) async {
    final question = await loadTodayQuestion();
    if (question == null) return;
    final updated = question.copyWith(answer: answer);
    await saveTodayQuestion(updated);
  }
}