import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/home_card.dart';
import 'map_screen.dart';
import 'ai_recommend_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';
import 'd_day_screen.dart';
import 'daily_question_screen.dart';
import 'pet_tycoon_screen.dart';
import 'gallery_screen.dart';
import 'ai_counselor_screen.dart';
import 'diary_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = <Widget>[
      // 인스타 감성 메인 홈: 카드형 주요 기능 진입점
      ListView(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        children: [
          Text(
            'Couple Date Map',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: 24),
          HomeCard(
            title: 'D-Day',
            subtitle: '우리의 기념일을 예쁘게',
            icon: Icons.cake,
            color: AppTheme.cardAccentColors[0],
            screen: DDayScreen(),
          ),
          HomeCard(
            title: '1일 1문',
            subtitle: '매일 서로에게 답하는 질문',
            icon: Icons.question_answer,
            color: AppTheme.cardAccentColors[1],
            screen: DailyQuestionScreen(),
          ),
          HomeCard(
            title: '커플 팻/인테리어',
            subtitle: '함께 키우는 러브팻, 방 꾸미기',
            icon: Icons.pets,
            color: AppTheme.cardAccentColors[2],
            screen: PetTycoonScreen(),
          ),
          HomeCard(
            title: '커플 갤러리',
            subtitle: '인생네컷, 추억 사진첩',
            icon: Icons.photo_library,
            color: AppTheme.cardAccentColors[3],
            screen: GalleryScreen(),
          ),
          HomeCard(
            title: 'AI 심리상담',
            subtitle: '고민/감정 챗봇',
            icon: Icons.chat_bubble,
            color: AppTheme.cardAccentColors[4],
            screen: AICounselorScreen(),
          ),
          HomeCard(
            title: '커플 다이어리',
            subtitle: '칼린더에 추억 기록',
            icon: Icons.calendar_month,
            color: AppTheme.cardAccentColors[5],
            screen: DiaryScreen(),
          ),
        ],
      ),
      MapScreen(),
      AIRecommendScreen(),
      FavoritesScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
