import '../models/interior_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class InteriorService {
  static const _key = 'user_interior_items';

  Future<List<InteriorItem>> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null) return [];
    final List data = jsonDecode(jsonStr);
    return data.map((e) => InteriorItem.fromJson(e)).toList();
  }

  Future<void> saveItems(List<InteriorItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final data = items.map((e) => e.toJson()).toList();
    await prefs.setString(_key, jsonEncode(data));
  }
}
