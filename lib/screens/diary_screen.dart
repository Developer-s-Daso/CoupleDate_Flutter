import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/diary_entry.dart';
import '../widgets/calendar_widget.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  List<DiaryEntry> entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('diary_entries');
    if (saved != null) {
      final List<dynamic> decoded = jsonDecode(saved);
      setState(() {
        entries = decoded.map((e) => DiaryEntry.fromJson(e)).toList();
      });
    } else {
      // 최초 실행 시 샘플 데이터 제공
      setState(() {
        entries = [
          DiaryEntry(date: DateTime.now(), content: '오늘은 정말 행복한 하루였다!', imageUrl: null),
          DiaryEntry(date: DateTime.now().subtract(Duration(days: 2)), content: '카페 데이트 ☕️', imageUrl: null),
        ];
      });
      await _saveEntries();
    }
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('diary_entries', jsonEncode(entries.map((e) => e.toJson()).toList()));
  }

  void showEntry(DiaryEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${entry.date.year}.${entry.date.month}.${entry.date.day}'),
        content: Text(entry.content),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('닫기'))],
      ),
    );
  }

  void addEntry() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final existingIdx = entries.indexWhere((e) =>
      e.date.year == today.year && e.date.month == today.month && e.date.day == today.day);
    final controller = TextEditingController(
      text: existingIdx != -1 ? entries[existingIdx].content : '',
    );
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('오늘의 다이어리'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: '오늘의 기록을 입력하세요'),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('취소')),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text), child: Text('저장')),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        if (existingIdx != -1) {
          entries[existingIdx] = DiaryEntry(date: today, content: result.trim(), imageUrl: null);
        } else {
          entries.add(DiaryEntry(date: today, content: result.trim(), imageUrl: null));
        }
      });
      await _saveEntries();
    }
  }

  void resetEntries() async {
    setState(() {
      entries = [
        DiaryEntry(date: DateTime.now(), content: '오늘은 정말 행복한 하루였다!', imageUrl: null),
        DiaryEntry(date: DateTime.now().subtract(Duration(days: 2)), content: '카페 데이트 ☕️', imageUrl: null),
      ];
    });
    await _saveEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Diary',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CalendarWidget(
              entries: entries,
              onTapEntry: (entry) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('${entry.date.year}.${entry.date.month}.${entry.date.day}'),
                    content: Text(entry.content.isNotEmpty ? entry.content : '기록이 없습니다.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('닫기'),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (entries.isEmpty)
              Center(
                child: Text(
                  'No entries yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      entries[index].content,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      entries[index].date.toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withAlpha((255 * 0.6).round()),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addEntry,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
    );
  }
}
