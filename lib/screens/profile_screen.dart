import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.mint,
              child: Icon(Icons.person, size: 48, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text('커플 닉네임', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('이메일: example@email.com', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.settings, color: AppTheme.mint),
              title: const Text('앱 설정'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout, color: AppTheme.mint),
              title: const Text('로그아웃'),
              onTap: () {},
            ),
            const Spacer(),
            const Text('Made with ♥ by CoupleMap', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
