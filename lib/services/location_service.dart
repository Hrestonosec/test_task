import 'package:geolocator/geolocator.dart';

// LocationService class provides functionality to get the user's current location
class LocationService {
  // Method to get the current location of the user
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission
        permission; // Variable to store the location permission status

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Сервіс геолокації вимкнено');
    }

    // Check the current location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Request permission if it is denied or permanently denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception(
            'Геолокація заборонена'); // Throw an exception if permission is still denied
      }
    }

    // Return the current position (latitude, longitude, etc.) if permission is granted
    return await Geolocator.getCurrentPosition();
  }
}
