import 'gallery_item.dart';

class GalleryFolder {
  final String name;
  final List<GalleryItem> items;
  GalleryFolder({required this.name, required this.items});

  Map<String, dynamic> toJson() => {
        'name': name,
        'items': items.map((e) => e.toJson()).toList(),
      };

  factory GalleryFolder.fromJson(Map<String, dynamic> json) => GalleryFolder(
        name: json['name'] as String,
        items: (json['items'] as List<dynamic>)
            .map((e) => GalleryItem.fromJson(e))
            .toList(),
      );
}
