import '../models/interior_item.dart';
import '../services/pet_service.dart';
import '../services/interior_service.dart';

Future<void> onBuyItem(InteriorItem item) async {
  final petService = PetService();
  final pet = await petService.loadPet();
  if (pet.point >= 50) {
    pet.usePoint(50);
    final interiorService = InteriorService();
    final items = await interiorService.loadItems();
    final idx = items.indexWhere((e) => e.id == item.id);
    if (idx != -1) items[idx].owned = true;
    await interiorService.saveItems(items);
    await petService.savePet(pet);
  } else {
    // 포인트 부족 안내
  }
}
