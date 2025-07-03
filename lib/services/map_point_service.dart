import 'pet_service.dart';

Future<void> onPlaceVisited() async {
  final petService = PetService();
  final pet = await petService.loadPet();
  pet.addPoint(10); // 방문 시 10포인트 적립
  pet.gainExp(20);  // 경험치도 추가
  await petService.savePet(pet);
  // 방문 기록 저장 등 추가 구현 가능
}
