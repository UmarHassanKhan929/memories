import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart';
import 'package:memoryplaces/helpers/db_helper.dart';
import '../models/place.dart';
import 'dart:io';
import '../helpers/location_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> addPlace(String title, String description, File image,
      PlaceLocation pickedLocation) async {
    final address = await LocationHelper.getPlaceAddress(
        latitude: pickedLocation.latitude, longitude: pickedLocation.longitude);

    final updatedLocation = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: address);

    final newPlace = Place(
        id: DateTime.now().toString(),
        title: title,
        description: description,
        location: updatedLocation,
        image: image);

    _items.add(newPlace);
    notifyListeners();

    DBHelper.insert('place', {
      'id': newPlace.id,
      'title': newPlace.title,
      'description': newPlace.description,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location!.latitude,
      'loc_lng': newPlace.location!.longitude,
      'address': newPlace.location?.address as String,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final datalist = await DBHelper.getData('place');
    _items = datalist.map((e) {
      return Place(
          id: e['id'],
          title: e['title'],
          description: e['description'],
          location: PlaceLocation(
              latitude: e['loc_lat'],
              longitude: e['loc_lng'],
              address: e['address']),
          image: File(e['image']));
    }).toList();
    notifyListeners();
  }

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
