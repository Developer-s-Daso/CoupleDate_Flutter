class DiaryEntry {
  final DateTime date;
  final String content;
  final String? imageUrl;

  DiaryEntry({required this.date, required this.content, this.imageUrl});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'content': content,
        'imageUrl': imageUrl,
      };

  factory DiaryEntry.fromJson(Map<String, dynamic> json) => DiaryEntry(
        date: DateTime.parse(json['date'] as String),
        content: json['content'] as String,
        imageUrl: json['imageUrl'] as String?,
      );
}
