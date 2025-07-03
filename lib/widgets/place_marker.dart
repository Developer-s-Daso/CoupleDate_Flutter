import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/place.dart';

Marker buildPlaceMarker(Place place, {void Function()? onTap}) {
  return Marker(
    markerId: MarkerId(place.id),
    position: LatLng(place.lat, place.lng),
    infoWindow: InfoWindow(title: place.name, snippet: place.address),
    onTap: onTap,
  );
}
