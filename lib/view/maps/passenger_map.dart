
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class PassengerMap extends StatefulWidget {
const PassengerMap({super.key});

@override
State<PassengerMap> createState() =>
_PassengerMapState();
}

class _PassengerMapState
extends State<PassengerMap> {

  LatLng? currentLocation;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

// =========================
// GET CURRENT LOCATION
// =========================

  Future<void> getCurrentLocation() async {
// LOCATION SERVICES OFF
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

// PERMISSION CHECK
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
      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Location permission required",
          ),
        ),
      );

      setState(() {
        isLoading = false;
      });

      return;
    }

// GET GPS
    Position position =
    await Geolocator
        .getCurrentPosition(
      desiredAccuracy:
      LocationAccuracy.high,
    );

    print(
      "Passenger Location: "
          "${position.latitude}, "
          "${position.longitude}",
    );

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
// LOADING
    if (isLoading) {
      return const Center(

        child:
        CircularProgressIndicator(),
      );
    }

// NO LOCATION
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

                Icons.my_location,

                size: 45,

                color: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}