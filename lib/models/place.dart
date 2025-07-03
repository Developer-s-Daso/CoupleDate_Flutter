class Place {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final String address;
  final String? category;
  final String? phone;
  final String? imageUrl;

  Place({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.address,
    this.category,
    this.phone,
    this.imageUrl,
  });

  factory Place.fromKakaoJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] ?? json['place_url'],
      name: json['place_name'],
      lat: double.parse(json['y']),
      lng: double.parse(json['x']),
      address: json['road_address_name'] ?? json['address_name'],
      category: json['category_name'],
      phone: json['phone'],
      imageUrl: null,
    );
  }
}
