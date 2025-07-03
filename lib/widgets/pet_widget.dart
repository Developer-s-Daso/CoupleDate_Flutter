import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/pet.dart';

class PetWidget extends StatelessWidget {
  final Pet pet;
  final String animationState; // 'idle', 'walk', 'jump' 등

  const PetWidget({required this.pet, this.animationState = 'idle', super.key});

  @override
  Widget build(BuildContext context) {
    String asset;
    switch (pet.type) {
      case PetType.dog:
        asset = 'assets/lottie/dog_$animationState.json';
        break;
      case PetType.cat:
        asset = 'assets/lottie/cat_$animationState.json';
        break;
      case PetType.rabbit:
        asset = 'assets/lottie/rabbit_$animationState.json';
        break;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.brown[50],
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.brown, width: 2),
          ),
          child: Lottie.asset(
            asset,
            width: 120,
            height: 120,
            repeat: true,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.pets, size: 80, color: Colors.brown),
          ),
        ),
        SizedBox(height: 8),
        Text(
          pet.type.name == 'dog' ? '강아지' : pet.type.name == 'cat' ? '고양이' : '토끼',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text('Lv.${pet.level}  EXP: ${pet.exp}', style: TextStyle(color: Colors.grey)),
        Text('Point: ${pet.point}', style: TextStyle(color: Colors.blue)),
      ],
    );
  }
}
