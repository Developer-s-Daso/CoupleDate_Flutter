import '../models/pet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PetService {
  static const _petKey = 'user_pet';

  Future<Pet> loadPet() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_petKey);
    if (jsonStr == null) {
      // 기본 펫 생성
      return Pet(type: PetType.dog);
    }
    final data = jsonDecode(jsonStr);
    return Pet.fromJson(data);
  }

  Future<void> savePet(Pet pet) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_petKey, jsonEncode(pet.toJson()));
  }
}
