import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class DriverMap extends StatefulWidget {
const DriverMap({super.key});

@override
State<DriverMap> createState() =>
_DriverMapState();
}

class _DriverMapState
extends State<DriverMap> {

  LatLng? currentLocation;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled =
    await Geolocator
        .isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator
          .openLocationSettings();

      setState(() {
        isLoading = false;
      });

      return;
    }

    LocationPermission permission =
    await Geolocator
        .checkPermission();

    if (permission ==
        LocationPermission.denied) {
      permission =
      await Geolocator
          .requestPermission();
    }

    if (permission ==
        LocationPermission.denied ||
        permission ==
            LocationPermission.deniedForever) {
      setState(() {
        isLoading = false;
      });

      return;
    }

    Position position =
    await Geolocator
        .getCurrentPosition();

    setState(() {
      currentLocation = LatLng(

        position.latitude,

        position.longitude,
      );

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child:
        CircularProgressIndicator(),
      );
    }

    if (currentLocation == null) {
      return const Center(
        child: Text(
          "Unable to get location",
        ),
      );
    }

    return FlutterMap(

      options: MapOptions(

        initialCenter:
        currentLocation!,

        initialZoom: 16,
      ),

      children: [

        TileLayer(

          urlTemplate:
          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

          userAgentPackageName:
          'com.saferide.zambia',
        ),

        MarkerLayer(

          markers: [

            Marker(

              point:
              currentLocation!,

              width: 80,

              height: 80,

              child: const Icon(

                Icons.directions_bus,

                color: Colors.green,

                size: 45,
              ),
            ),
          ],
        ),
      ],
    );
  }
}