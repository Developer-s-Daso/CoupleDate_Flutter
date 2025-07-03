enum PetType { dog, cat, rabbit }

class Pet {
  final PetType type;
  int level;
  int exp;
  int point;
  String? equippedAccessory;
  String? equippedRoom;
  List<String> ownedAccessories;
  List<String> ownedRooms;
  int hunger; // 0~100
  int mood;   // 0~100
  DateTime? lastWalked;
  DateTime? lastFed;

  Pet({
    required this.type,
    this.level = 1,
    this.exp = 0,
    this.point = 0,
    this.equippedAccessory,
    this.equippedRoom,
    this.ownedAccessories = const [],
    this.ownedRooms = const [],
    this.hunger = 100,
    this.mood = 100,
    this.lastWalked,
    this.lastFed,
  });

  bool canLevelUp() => exp >= 100 * level;

  void gainExp(int amount) {
    exp += amount;
    while (canLevelUp()) {
      exp -= 100 * level;
      level++;
    }
  }

  void addPoint(int amount) => point += amount;
  void usePoint(int amount) => point -= amount;

  void feed(int food) {
    hunger = (hunger + food).clamp(0, 100);
    lastFed = DateTime.now();
  }

  void walk() {
    mood = (mood + 10).clamp(0, 100);
    hunger = (hunger - 10).clamp(0, 100);
    lastWalked = DateTime.now();
  }

  void addAccessory(String accessory) {
    if (!ownedAccessories.contains(accessory)) {
      ownedAccessories = [...ownedAccessories, accessory];
    }
  }

  void addRoom(String room) {
    if (!ownedRooms.contains(room)) {
      ownedRooms = [...ownedRooms, room];
    }
  }

  Map<String, dynamic> toJson() => {
    'type': type.index,
    'level': level,
    'exp': exp,
    'point': point,
    'equippedAccessory': equippedAccessory,
    'equippedRoom': equippedRoom,
    'ownedAccessories': ownedAccessories,
    'ownedRooms': ownedRooms,
    'hunger': hunger,
    'mood': mood,
    'lastWalked': lastWalked?.toIso8601String(),
    'lastFed': lastFed?.toIso8601String(),
  };

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
    type: PetType.values[json['type']],
    level: json['level'],
    exp: json['exp'],
    point: json['point'],
    equippedAccessory: json['equippedAccessory'],
    equippedRoom: json['equippedRoom'],
    ownedAccessories: (json['ownedAccessories'] as List?)?.map((e) => e as String).toList() ?? [],
    ownedRooms: (json['ownedRooms'] as List?)?.map((e) => e as String).toList() ?? [],
    hunger: json['hunger'] ?? 100,
    mood: json['mood'] ?? 100,
    lastWalked: json['lastWalked'] != null ? DateTime.tryParse(json['lastWalked']) : null,
    lastFed: json['lastFed'] != null ? DateTime.tryParse(json['lastFed']) : null,
  );
}
