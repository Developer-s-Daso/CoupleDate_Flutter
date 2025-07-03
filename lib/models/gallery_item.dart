class GalleryItem {
  final String imageUrl;
  final String? caption;
  final DateTime date;
  GalleryItem({required this.imageUrl, this.caption, required this.date});

  Map<String, dynamic> toJson() => {
        'imageUrl': imageUrl,
        'caption': caption,
        'date': date.toIso8601String(),
      };

  factory GalleryItem.fromJson(Map<String, dynamic> json) => GalleryItem(
        imageUrl: json['imageUrl'] as String,
        caption: json['caption'] as String?,
        date: DateTime.parse(json['date'] as String),
      );
}
