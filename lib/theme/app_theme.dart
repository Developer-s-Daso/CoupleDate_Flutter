import 'package:flutter/material.dart';

class AppTheme {
  // MZ 세대를 위한 트렌디하고 세련된 색상 팔레트
  static const Map<String, Color> trendyColors = {
    'primaryGreen': Color(0xFF264653), // 깊고 세련된 그린
    'accentCoral': Color(0xFFE76F51), // 생기 있는 코랄 포인트
    'secondaryYellow': Color(0xFFE9C46A), // 부드러운 옐로우
    'lightBackground': Color(0xFFF7F9FA), // 깔끔한 오프화이트 배경
    'cardColor': Color(0xFFFFFFFF), // 카드 색상
    'textColor': Color(0xFF333333), // 기본 텍스트 색상
    'subtleTextColor': Color(0xFF575757), // 보조 텍스트 색상
    // D-Day 등에서 사용하는 추가 색상
    'blue': Color(0xFF3A86FF), // 블루
    'lightSkyBlue': Color(0xFFA5C9FF), // 파스텔 하늘
    'paleBlue': Color(0xFFE3F0FF), // 연하늘
    'mint': Color(0xFF7DDFF6), // 맑은 민트블루
    'lightMint': Color(0xFFE0FBF8), // 파스텔 민트블루 배경
    'cardWhite': Color(0xFFFFFFFF), // 화이트 카드
    'blueText': Color(0xFF4F8CFF), // 파스텔 블루 텍스트
  };

  static const List<Color> cardAccentColors = [
    Color(0xFFFFE082), // 밝은 옐로우
    Color(0xFFFFB6B6), // 밝은 코랄핑크
    Color(0xFFA7FFEB), // 밝은 민트
    Color(0xFFB3E5FC), // 밝은 하늘색
    Color(0xFFD1C4E9), // 밝은 라벤더
    Color(0xFFFFF9C4), // 밝은 크림
  ];

  // 기존 static const Color들도 trendyColors를 통해 접근하도록 getter 추가
  static Color get primaryGreen => trendyColors['primaryGreen']!;
  static Color get accentCoral => trendyColors['accentCoral']!;
  static Color get secondaryYellow => trendyColors['secondaryYellow']!;
  static Color get lightBackground => trendyColors['lightBackground']!;
  static Color get cardColor => trendyColors['cardColor']!;
  static Color get textColor => trendyColors['textColor']!;
  static Color get subtleTextColor => trendyColors['subtleTextColor']!;
  static Color get blue => trendyColors['blue']!;
  static Color get lightSkyBlue => trendyColors['lightSkyBlue']!;
  static Color get paleBlue => trendyColors['paleBlue']!;
  static Color get mint => trendyColors['mint']!;
  static Color get lightMint => trendyColors['lightMint']!;
  static Color get cardWhite => trendyColors['cardWhite']!;
  static Color get blueText => trendyColors['blueText']!;

  static ThemeData get themeData => ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: lightBackground,
    fontFamily: 'NotoSansKR',
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      primary: primaryGreen,
      secondary: accentCoral,
      surface: cardColor,
      onPrimary: Colors.white, // primaryGreen 위의 텍스트
      onSecondary: Colors.white, // accentCoral 위의 텍스트
      onSurface: textColor,
      error: Colors.redAccent,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryGreen,
      elevation: 2,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
        fontFamily: 'NotoSansKR',
      ),
    ),
    cardTheme: CardThemeData(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      elevation: 4,
      shadowColor: Colors.black.withAlpha((255 * 0.1).round()),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: cardColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentCoral,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'NotoSansKR',
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryGreen,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'NotoSansKR',
        ),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textColor,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: subtleTextColor,
        height: 1.5,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryGreen, width: 2),
      ),
      labelStyle: TextStyle(color: subtleTextColor),
    ),
  );
}

final ThemeData appTheme = AppTheme.themeData;
