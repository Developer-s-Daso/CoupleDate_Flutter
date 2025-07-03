class DDay {
  final DateTime date;
  final String label;
  DDay({required this.date, required this.label});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'label': label,
      };

  factory DDay.fromJson(Map<String, dynamic> json) => DDay(
        date: DateTime.parse(json['date'] as String),
        label: json['label'] as String,
      );
}
