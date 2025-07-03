import 'package:flutter/material.dart';
import '../models/question.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final ValueChanged<String> onAnswer;
  const QuestionCard({super.key, required this.question, required this.onAnswer});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: question.answer);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(question.text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: controller,
              decoration: InputDecoration(hintText: '답변을 입력하세요'),
              onSubmitted: onAnswer,
            ),
          ],
        ),
      ),
    );
  }
}
