import 'package:flutter/material.dart';
import '../models/diary_entry.dart';

class CalendarWidget extends StatefulWidget {
  final List<DiaryEntry> entries;
  final void Function(DiaryEntry)? onTapEntry;
  const CalendarWidget({super.key, required this.entries, this.onTapEntry});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late int selectedYear;
  late int selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedYear = now.year;
    selectedMonth = now.month;
  }

  void _goToPrevMonth() {
    setState(() {
      if (selectedMonth == 1) {
        selectedYear--;
        selectedMonth = 12;
      } else {
        selectedMonth--;
      }
    });
  }

  void _goToNextMonth() {
    setState(() {
      if (selectedMonth == 12) {
        selectedYear++;
        selectedMonth = 1;
      } else {
        selectedMonth++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(selectedYear, selectedMonth, 1);
    final lastDay = DateTime(selectedYear, selectedMonth + 1, 0);
    final daysInMonth = lastDay.day;
    final days = List.generate(daysInMonth, (i) => DateTime(selectedYear, selectedMonth, i + 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: _goToPrevMonth,
            ),
            Text(
              '$selectedYear년 $selectedMonth월',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: _goToNextMonth,
            ),
          ],
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: days.length,
          itemBuilder: (context, idx) {
            final day = days[idx];
            final entry = widget.entries.firstWhere(
              (e) => e.date.year == day.year && e.date.month == day.month && e.date.day == day.day,
              orElse: () => DiaryEntry(date: day, content: '', imageUrl: null),
            );
            final hasEntry = entry.content.isNotEmpty;
            return GestureDetector(
              onTap: hasEntry && widget.onTapEntry != null ? () => widget.onTapEntry!(entry) : null,
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: hasEntry ? Color(0xFFB2F1E7) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: hasEntry ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
