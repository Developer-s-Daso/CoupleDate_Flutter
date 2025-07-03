import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet.dart';
import '../widgets/pet_widget.dart';

class PetTycoonScreen extends StatefulWidget {
  const PetTycoonScreen({super.key});

  @override
  State<PetTycoonScreen> createState() => _PetTycoonScreenState();
}

class _PetTycoonScreenState extends State<PetTycoonScreen> {
  Pet? pet;
  String animationState = 'idle';

  @override
  void initState() {
    super.initState();
    _loadPet();
  }

  Future<void> _loadPet() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('pet_tycoon');
    if (saved != null) {
      setState(() {
        pet = Pet.fromJson(jsonDecode(saved));
      });
    } else {
      setState(() {
        pet = Pet(type: PetType.dog);
      });
      await _savePet();
    }
  }

  Future<void> _savePet() async {
    final prefs = await SharedPreferences.getInstance();
    if (pet != null) {
      await prefs.setString('pet_tycoon', jsonEncode(pet!.toJson()));
    }
  }

  void gainExp() async {
    setState(() {
      if (pet == null) return;
      pet!.exp += 10;
      if (pet!.exp >= 100) {
        pet!.level += 1;
        pet!.exp = 0;
      }
      animationState = 'jump';
    });
    await Future.delayed(Duration(milliseconds: 800));
    setState(() {
      animationState = 'idle';
    });
    await _savePet();
  }

  void walkPet() async {
    setState(() {
      animationState = 'walk';
    });
    await Future.delayed(Duration(milliseconds: 1200));
    setState(() {
      animationState = 'idle';
    });
  }

  void resetPet() async {
    setState(() {
      pet = Pet(type: PetType.dog);
      animationState = 'idle';
    });
    await _savePet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pet Tycoon',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: pet == null
          ? Center(
              child: Text(
                'No pet found',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: PetWidget(
                    pet: pet!,
                    animationState: animationState,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: gainExp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Gain Experience',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
