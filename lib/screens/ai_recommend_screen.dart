import 'package:flutter/material.dart';
import '../services/gemini_ai_service.dart';
import '../theme/app_theme.dart';



class AIRecommendScreen extends StatefulWidget {
  const AIRecommendScreen({super.key});

  @override
  State<AIRecommendScreen> createState() => _AIRecommendScreenState();
}

class _AIRecommendScreenState extends State<AIRecommendScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();
  String _preference = '카페';
  String _mood = '로맨틱';
  String _budget = '중간';
  String _time = '오후';
  String? _result;
  bool _loading = false;
  final GeminiAIService _aiService = GeminiAIService();

  Future<void> _getRecommendation() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final res = await _aiService.recommendPlaces(
        location: _locationController.text,
        preference: _preference,
        mood: _mood,
        budget: _budget,
        time: _time,
      );
      setState(() => _result = res);
    } catch (e) {
      setState(() => _result = 'AI 추천 실패: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppTheme.lightSkyBlue, // 연한 하늘색
      body: Stack(
        children: [
          // 상단 그라데이션 배경
          Container(
            height: 260,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.paleBlue, // 밝은 하늘색
                  AppTheme.lightMint, // 밝은 민트
                  AppTheme.lightSkyBlue, // 밝은 파스텔 블루
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              children: [
                const SizedBox(height: 18),
                // 상단 타이틀 & 아이콘
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
                    const SizedBox(width: 8),
                    Text(
                      'AI 데이트 추천',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // 입력 폼 카드
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _locationController,
                              decoration: InputDecoration(
                                labelText: '내 위치 (예: 강남역)',
                                prefixIcon: Icon(Icons.place, color: AppTheme.mint),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              validator: (v) => v == null || v.isEmpty ? '위치를 입력하세요' : null,
                            ),
                            const SizedBox(height: 16),
                            _PrettyDropdown(
                              value: _preference,
                              items: const ['카페', '맛집', '관광명소', '문화시설', '공원'],
                              label: '선호 카테고리',
                              icon: Icons.favorite,
                              onChanged: (v) => setState(() => _preference = v!),
                            ),
                            const SizedBox(height: 12),
                            _PrettyDropdown(
                              value: _mood,
                              items: const ['로맨틱', '활기찬', '조용한', '이색적인'],
                              label: '분위기',
                              icon: Icons.emoji_emotions,
                              onChanged: (v) => setState(() => _mood = v!),
                            ),
                            const SizedBox(height: 12),
                            _PrettyDropdown(
                              value: _budget,
                              items: const ['저렴', '중간', '고급'],
                              label: '예산',
                              icon: Icons.attach_money,
                              onChanged: (v) => setState(() => _budget = v!),
                            ),
                            const SizedBox(height: 12),
                            _PrettyDropdown(
                              value: _time,
                              items: const ['오전', '오후', '저녁', '야간'],
                              label: '시간대',
                              icon: Icons.access_time,
                              onChanged: (v) => setState(() => _time = v!),
                            ),
                            const SizedBox(height: 22),
                            SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  backgroundColor: AppTheme.paleBlue, // 연하늘
                                  foregroundColor: AppTheme.blueText, // 블루 텍스트
                                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                onPressed: _loading ? null : _getRecommendation,
                                child: _loading
                                    ? SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                                      )
                                    : Text('AI 추천 받기'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                if (_result != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.recommend, color: AppTheme.mint),
                                const SizedBox(width: 8),
                                Text('AI 추천 결과',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: AppTheme.mint,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _result!,
                              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 예쁜 드롭다운 위젯 (클래스 외부, 정상 위치)
class _PrettyDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final String label;
  final IconData icon;
  final ValueChanged<String?> onChanged;

  const _PrettyDropdown({
    required this.value,
    required this.items,
    required this.label,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Row(
                  children: [
                    Icon(icon, color: AppTheme.mint, size: 20),
                    const SizedBox(width: 8),
                    Text(e, style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      icon: Icon(Icons.expand_more, color: AppTheme.mint),
      dropdownColor: Colors.white,
    );
  }
}
