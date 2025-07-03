import 'package:flutter/material.dart';
import '../models/daily_question.dart';
import '../services/daily_question_service.dart';

class DailyQuestionScreen extends StatefulWidget {
  const DailyQuestionScreen({super.key});
  @override
  State<DailyQuestionScreen> createState() => _DailyQuestionScreenState();
}

class _DailyQuestionScreenState extends State<DailyQuestionScreen> {
  final DailyQuestionService _service = DailyQuestionService();
  DailyQuestion? _todayQuestion;
  bool _loading = true;
  bool _generating = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOrGenerate();
  }

  Future<void> _loadOrGenerate() async {
    setState(() => _loading = true);
    final loaded = await _service.loadTodayQuestion();
    if (loaded != null) {
      _controller.text = loaded.answer ?? '';
      setState(() {
        _todayQuestion = loaded;
        _loading = false;
      });
    } else {
      setState(() { _generating = true; });
      final text = await _service.generateTodayQuestion();
      final dateKey = DateTime.now();
      final q = DailyQuestion(
        text: text,
        dateKey: '${dateKey.year}-${dateKey.month.toString().padLeft(2, '0')}-${dateKey.day.toString().padLeft(2, '0')}',
      );
      await _service.saveTodayQuestion(q);
      setState(() {
        _todayQuestion = q;
        _loading = false;
        _generating = false;
      });
    }
  }

  Future<void> _saveAnswer(String answer) async {
    if (_todayQuestion == null) return;
    final updated = _todayQuestion!.copyWith(answer: answer);
    await _service.saveTodayQuestion(updated);
    setState(() {
      _todayQuestion = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1일 1문', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '질문 새로고침',
            onPressed: _loading || _generating ? null : () async {
              await _loadOrGenerate();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _todayQuestion == null
              ? const Center(child: Text('질문을 불러올 수 없습니다.'))
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _todayQuestion!.text,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          labelText: '오늘의 답변',
                          border: OutlineInputBorder(),
                        ),
                        minLines: 2,
                        maxLines: 5,
                        onChanged: (value) => _saveAnswer(value),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await _saveAnswer(_controller.text);
                          FocusScope.of(context).unfocus();
                        },
                        child: const Text('답변 저장'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
