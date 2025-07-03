import 'package:flutter/material.dart';
import '../services/favorites_service.dart';

import '../models/place.dart';
import 'place_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  // final KakaoApiService _kakaoService = KakaoApiService();
  List<Place> _favoritePlaces = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _loading = true);
    final ids = await _favoritesService.getFavorites();
    List<Place> places = [];
    // 실제 서비스에서는 DB나 캐시를 사용해야 하지만,
    // 여기서는 즐겨찾기 추가 시점의 정보를 함께 저장하는 구조가 필요합니다.
    // 임시로 즐겨찾기 id만 보여줍니다.
    for (final id in ids) {
      places.add(Place(
        id: id,
        name: '즐겨찾기 장소 ($id)',
        lat: 0,
        lng: 0,
        address: '',
      ));
    }
    setState(() {
      _favoritePlaces = places;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _favoritePlaces.isEmpty
              ? const Center(child: Text('즐겨찾기한 장소가 없습니다'))
              : ListView.builder(
                  itemCount: _favoritePlaces.length,
                  itemBuilder: (context, idx) {
                    final place = _favoritePlaces[idx];
                    return ListTile(
                      title: Text(place.name),
                      subtitle: Text(place.address),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlaceDetailScreen(place: place),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
