import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  static Future<void> openGoogleMaps(String destinationName) async {
    try {
      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          throw 'Location permissions are permanently denied. Please enable them in settings.';
        }
      }

      // Get the user's current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double currentLat = position.latitude;
      double currentLng = position.longitude;

      // Encode destination to make it URL safe
      String encodedDestination = Uri.encodeComponent(destinationName);

      final String googleMapsUrl =
          "https://www.google.com/maps/dir/?api=1&origin=$currentLat,$currentLng&destination=$encodedDestination&travelmode=driving";

      final Uri url = Uri.parse(googleMapsUrl);

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        // Apple Maps fallback
        final String appleMapsUrl =
            "https://maps.apple.com/?saddr=$currentLat,$currentLng&daddr=$encodedDestination&dirflg=d";

        final Uri appleUrl = Uri.parse(appleMapsUrl);
        if (await canLaunchUrl(appleUrl)) {
          await launchUrl(appleUrl, mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not open the map. Please install Google Maps or Apple Maps.';
        }
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }
}
