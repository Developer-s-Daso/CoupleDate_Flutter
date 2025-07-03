// 구글 지도 관련 서비스 (위치 권한, 지도 초기화 등)

import 'package:location/location.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleMapsService {
  final Location _location = Location();

  Future<LocationData?> getCurrentLocation() async {
    final useMock = dotenv.env['USE_MOCK'] == 'true';
    if (useMock) {
      // Mock 위치 데이터 (서울 시청)
      return LocationData.fromMap({
        'latitude': 37.5665,
        'longitude': 126.9780,
        'accuracy': 10.0,
        'altitude': 0.0,
        'speed': 0.0,
        'speed_accuracy': 0.0,
        'heading': 0.0,
        'time': DateTime.now().millisecondsSinceEpoch,
      });
    }
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await _location.getLocation();
  }
}
