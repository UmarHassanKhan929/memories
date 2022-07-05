import 'package:flutter/material.dart';
import 'package:memoryplaces/providers/great_places.dart';
import 'package:memoryplaces/screens/add_place_screen.dart';
import 'package:memoryplaces/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';
import 'screens/places_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GreatPlaces(),
      child: MaterialApp(
          title: 'Memories',
          theme: ThemeData(
            primarySwatch: Colors.pink,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: PlacesListScreen(),
          routes: {
            AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
            PlaceDetailScreen.routeName: (context) => PlaceDetailScreen(),
          }),
    );
  }
}
