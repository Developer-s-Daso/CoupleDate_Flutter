import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.mint, // 밝은 하늘색
      unselectedItemColor: AppTheme.lightMint, // 밝은 민트
      backgroundColor: AppTheme.lightSkyBlue, // 연한 하늘색 배경
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: '지도'),
        BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'AI추천'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '즐겨찾기'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '내정보'),
      ],
    );
  }
}
