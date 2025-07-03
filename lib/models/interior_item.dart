enum InteriorType { furniture, wall, floor, toy, accessory }

class InteriorItem {
  final String id;
  final String name;
  final InteriorType type;
  final String assetPath;
  bool owned;

  InteriorItem({
    required this.id,
    required this.name,
    required this.type,
    required this.assetPath,
    this.owned = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.index,
    'assetPath': assetPath,
    'owned': owned,
  };

  factory InteriorItem.fromJson(Map<String, dynamic> json) => InteriorItem(
    id: json['id'],
    name: json['name'],
    type: InteriorType.values[json['type']],
    assetPath: json['assetPath'],
    owned: json['owned'],
  );
}
