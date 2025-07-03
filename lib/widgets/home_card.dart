import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? color;
  final Widget screen;

  const HomeCard({super.key, required this.title, required this.subtitle, required this.icon, required this.color, required this.screen});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: Card(
        color: color != null
            ? color!.withOpacity(0.45) // 더 밝고 투명하게
            : const Color(0x26F06292),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.symmetric(vertical: 10),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color != null ? color!.withOpacity(0.8) : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: color != null ? color!.withOpacity(0.25) : Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(12),
                child: Icon(icon, size: 32, color: Colors.white),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.7))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
