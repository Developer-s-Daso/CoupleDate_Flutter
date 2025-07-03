/// 1일 1문(커플 질문) 모델
class DailyQuestion {
  final String text;
  final String dateKey; // yyyy-MM-dd
  final String? answer;

  DailyQuestion({required this.text, required this.dateKey, this.answer});

  factory DailyQuestion.fromJson(Map<String, dynamic> json) => DailyQuestion(
        text: json['text'] as String,
        dateKey: json['dateKey'] as String,
        answer: json['answer'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'dateKey': dateKey,
        'answer': answer,
      };

  DailyQuestion copyWith({String? text, String? dateKey, String? answer}) => DailyQuestion(
        text: text ?? this.text,
        dateKey: dateKey ?? this.dateKey,
        answer: answer ?? this.answer,
      );
}