import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/google_maps_service.dart';
import '../services/kakao_api_service.dart';
import '../models/place.dart';
import '../widgets/place_marker.dart';
import '../widgets/category_chip.dart';
import 'place_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // GoogleMapController? _controller; // 사용하지 않으므로 주석 처리 또는 삭제
  LatLng? _currentPosition;
  final GoogleMapsService _mapsService = GoogleMapsService();
  final KakaoApiService _kakaoService = KakaoApiService();
  List<Place> _places = [];
  final List<String> _categories = ['카페', '맛집', '관광명소', '문화시설', '공원'];
  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    _initLocationAndPlaces();
  }

  Future<void> _initLocationAndPlaces() async {
    final locationData = await _mapsService.getCurrentLocation();
    if (locationData != null) {
      final LatLng pos = LatLng(locationData.latitude!, locationData.longitude!);
      setState(() {
        _currentPosition = pos;
      });
      await _fetchPlaces();
    }
  }

  Future<void> _fetchPlaces() async {
    if (_currentPosition == null) return;
    final kakaoResults = await _kakaoService.searchPlaces(
      _categories[_selectedCategory],
      x: _currentPosition!.longitude,
      y: _currentPosition!.latitude,
    );
    setState(() {
      _places = kakaoResults.map<Place>((json) => Place.fromKakaoJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final useMock = dotenv.env['USE_MOCK'] == 'true';
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (useMock || apiKey == null || apiKey.isEmpty || apiKey == 'YOUR_GOOGLE_MAPS_API_KEY') {
      // Mock UI for debugging when USE_MOCK is true or API key is missing
      return Scaffold(
        appBar: AppBar(
          title: const Text('지도 (디버그 모드)'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemCount: _categories.length,
                itemBuilder: (context, idx) => CategoryChip(
                  label: _categories[idx],
                  selected: _selectedCategory == idx,
                  onTap: () async {
                    setState(() => _selectedCategory = idx);
                  },
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 100, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Google Maps API 키가 없거나 Mock 모드입니다.\n지도 대신 Mock 화면이 표시됩니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('지도'),
        centerTitle: true,
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        kToolbarHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 48,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            itemCount: _categories.length,
                            itemBuilder: (context, idx) => CategoryChip(
                              label: _categories[idx],
                              selected: _selectedCategory == idx,
                              onTap: () async {
                                setState(() => _selectedCategory = idx);
                                await _fetchPlaces();
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _currentPosition!,
                              zoom: 14,
                            ),
                            myLocationEnabled: true,
                            onMapCreated: (controller) {},
                            markers: {
                              Marker(
                                markerId: const MarkerId('me'),
                                position: _currentPosition!,
                                infoWindow: const InfoWindow(title: '내 위치'),
                              ),
                              ..._places.map((place) => buildPlaceMarker(
                                place,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PlaceDetailScreen(place: place),
                                    ),
                                  );
                                },
                              )),
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}