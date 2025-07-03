import 'package:flutter/material.dart';

class AppTheme {
  static const Color skyBlue = Color(0xFFB8EFFF); // 밝은 하늘색
  static const Color lightSkyBlue = Color(0xFFE6F7FF); // 연한 하늘+바다 느낌 배경
  static const Color blue = Color(0xFF3A5A98); // 블루(상단/포커스)
  static const Color blueText = Color(0xFF5D8AA8); // 파스텔 블루 텍스트
  static const Color mint = Color(0xFF7DDFF6); // 맑은 민트블루
  static const Color lightMint = Color(0xFFD0F4FF); // 파스텔 민트블루 배경
  static const Color paleBlue = Color(0xFFBEE3F7); // 연하늘(앱바)
  static const Color cardWhite = Color(0xFFFFFFFF);

  static ThemeData get themeData => ThemeData(
    brightness: Brightness.light,
    primaryColor: skyBlue,
    scaffoldBackgroundColor: lightSkyBlue,
    fontFamily: 'NotoSansKR',
    colorScheme: ColorScheme.fromSeed(
      seedColor: skyBlue,
      primary: skyBlue,
      secondary: Color(0xFFB2F1E7), // 밝은 민트(바다 느낌)
      background: lightSkyBlue,
      surface: cardWhite,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onBackground: Colors.black,
      onSurface: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: skyBlue,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: cardWhite,
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      buttonColor: Color(0xFFB2F1E7), // 밝은 민트
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
    ),
    // 배경에 하늘-바다 그라데이션 효과를 주고 싶다면, 각 스크린의 배경에 BoxDecoration(gradient: ...)을 적용하세요.
  );
}

final ThemeData appTheme = AppTheme.themeData;
