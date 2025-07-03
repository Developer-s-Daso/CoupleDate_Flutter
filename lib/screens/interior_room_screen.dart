import '../models/interior_item.dart';
import 'package:flutter/material.dart';

class InteriorRoomScreen extends StatefulWidget {
  final List<InteriorItem> items;
  const InteriorRoomScreen({required this.items, super.key});

  @override
  State<InteriorRoomScreen> createState() => _InteriorRoomScreenState();
}

class _InteriorRoomScreenState extends State<InteriorRoomScreen> {
  // 실제 앱에서는 위치 정보도 저장/불러오기 필요
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/room_bg.png'), // 방 배경
        ...widget.items.where((e) => e.owned).map((item) => Positioned(
          left: 100, // 실제로는 저장된 위치값 사용
          top: 200,
          child: Draggable(
            feedback: Image.asset(item.assetPath, width: 80),
            child: Image.asset(item.assetPath, width: 80),
            onDragEnd: (details) {
              // 위치 저장 로직 구현 필요
            },
          ),
        )),
      ],
    );
  }
}
