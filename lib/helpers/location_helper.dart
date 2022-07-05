// ignore: constant_identifier_names
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

const GOOGLE_API_KEY = '';

class LocationHelper {
  static String generateLocationPreviewImage({
    required double latitude,
    required double longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=15&size=610x300&maptype=roadmap&markers=color:red%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getPlaceAddress(
      {required double latitude, required double longitude}) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_API_KEY';
    final response = await http.get(Uri.parse(url));
    final jsonResponse = json.decode(response.body);
    final formattedAddress = jsonResponse['results'][0]['formatted_address'];
    return formattedAddress;
  }
}
