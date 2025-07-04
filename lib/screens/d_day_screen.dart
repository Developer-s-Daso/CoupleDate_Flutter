import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/d_day.dart';
import '../theme/app_theme.dart';

class DDayScreen extends StatefulWidget {
  const DDayScreen({super.key});

  @override
  State<DDayScreen> createState() => _DDayScreenState();
}

class _DDayScreenState extends State<DDayScreen> {
  List<DDay> dDays = [];
  DateTime? firstDate;

  @override
  void initState() {
    super.initState();
    _loadDDays();
  }

  Future<void> _loadDDays() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('d_days');
    final firstDateStr = prefs.getString('first_date');
    if (firstDateStr != null) {
      firstDate = DateTime.parse(firstDateStr);
    }
    if (saved != null) {
      final List<dynamic> decoded = jsonDecode(saved);
      setState(() {
        dDays = decoded.map((e) => DDay.fromJson(e)).toList();
      });
    } else {
      final now = DateTime.now();
      setState(() {
        firstDate = DateTime(now.year, now.month, now.day);
        dDays = [
          DDay(date: firstDate!, label: '처음 만난 날'),
          DDay(date: firstDate!.add(Duration(days: 100)), label: '100일'),
          DDay(date: firstDate!.add(Duration(days: 365)), label: '1주년'),
        ];
      });
      await _saveDDays();
      await _saveFirstDate();
    }
  }

  Future<void> _saveFirstDate() async {
    final prefs = await SharedPreferences.getInstance();
    if (firstDate != null) {
      await prefs.setString('first_date', firstDate!.toIso8601String());
    }
  }

  Future<void> _saveDDays() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('d_days', jsonEncode(dDays.map((e) => e.toJson()).toList()));
  }

  void resetDDays() async {
    final now = DateTime.now();
    setState(() {
      firstDate = DateTime(now.year, now.month, now.day);
      dDays = [
        DDay(date: firstDate!, label: '처음 만난 날'),
        DDay(date: firstDate!.add(Duration(days: 100)), label: '100일'),
        DDay(date: firstDate!.add(Duration(days: 365)), label: '1주년'),
      ];
    });
    await _saveDDays();
    await _saveFirstDate();
  }

  Future<void> pickFirstDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: firstDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: '처음 사귄 날짜를 선택하세요',
      confirmText: '설정',
      cancelText: '취소',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.blue,
              onPrimary: Colors.white,
              surface: AppTheme.lightSkyBlue,
              onSurface: AppTheme.blue,
            ), dialogTheme: DialogThemeData(backgroundColor: AppTheme.lightMint),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        firstDate = DateTime(picked.year, picked.month, picked.day);
        dDays = [
          DDay(date: firstDate!, label: '처음 만난 날'),
          DDay(date: firstDate!.add(Duration(days: 100)), label: '100일'),
          DDay(date: firstDate!.add(Duration(days: 365)), label: '1주년'),
        ];
      });
      await _saveDDays();
      await _saveFirstDate();
    }
  }

  int get daysSinceFirstDate {
    if (firstDate == null) return 0;
    final now = DateTime.now();
    return now.difference(firstDate!).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightSkyBlue,
      appBar: AppBar(
        backgroundColor: AppTheme.paleBlue,
        title: Text(
          'D-Day',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.blue,
          ),
        ),
        iconTheme: IconThemeData(color: AppTheme.blue),
        actions: [
          IconButton(
            icon: Icon(Icons.cake, color: AppTheme.blue),
            tooltip: '처음 사귄 날짜 설정',
            onPressed: pickFirstDate,
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: AppTheme.blue),
            tooltip: 'D-Day 초기화',
            onPressed: resetDDays,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (firstDate != null)
            Card(
              color: AppTheme.cardWhite,
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: Icon(Icons.favorite, color: AppTheme.mint),
                title: Text(
                  '처음 사귄 날: ${firstDate!.year}.${firstDate!.month}.${firstDate!.day}',
                  style: TextStyle(
                    color: AppTheme.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '오늘은 사귄 지 $daysSinceFirstDate일째!',
                  style: TextStyle(color: AppTheme.blueText),
                ),
              ),
            ),
          ...dDays.map((d) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: DDayCard(dday: d, today: DateTime.now()),
              )),
        ],
      ),
    );
  }
}

// DDayCard 위젯을 이 파일로 통합
class DDayCard extends StatelessWidget {
  final DDay dday;
  final DateTime today;
  const DDayCard({super.key, required this.dday, required this.today});

  @override
  Widget build(BuildContext context) {
    final diff = today.difference(dday.date).inDays;
    final dText = diff >= 0 ? 'D+$diff' : 'D$diff';
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: AppTheme.lightMint,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dday.label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.blue,
              ),
            ),
            SizedBox(height: 8),
            Text(
              dText,
              style: TextStyle(
                fontSize: 32,
                color: AppTheme.mint,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${dday.date.year}.${dday.date.month}.${dday.date.day}',
              style: TextStyle(color: AppTheme.blueText),
            ),
          ],
        ),
      ),
    );
  }
}
