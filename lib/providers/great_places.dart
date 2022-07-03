import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart';
import 'package:memoryplaces/helpers/db_helper.dart';
import '../models/place.dart';
import 'dart:io';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String title, String description, File image) {
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: title,
        description: description,
        location: null,
        image: image);

    _items.add(newPlace);
    notifyListeners();

    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'description': newPlace.description,
      'image': newPlace.image.path
    });
  }

  Future<void> fetchAndSetPlaces() async {
    final datalist = await DBHelper.getData('user_places');
    _items = datalist.map((e) {
      return Place(
          id: e['id'],
          title: e['title'],
          description: e['description'],
          location: null,
          image: File(e['image']));
    }).toList();
    notifyListeners();
  }
}
