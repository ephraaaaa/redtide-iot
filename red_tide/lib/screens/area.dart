import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: OpenStreetMapSearchAndPick(

        center: const LatLong(11.843738441810899, 124.81375905861583),
      
        onPicked: (pickedData) {
          debugPrint(pickedData.latLong.latitude.toString());
          debugPrint(pickedData.latLong.longitude.toString());
          debugPrint(pickedData.address.toString());
        },
      ),
    );
  }
}
