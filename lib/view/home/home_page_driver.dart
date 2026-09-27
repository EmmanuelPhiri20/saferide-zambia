import 'package:flutter/material.dart';

import 'driver_home_tab.dart';
import 'driver_trips_tab.dart';
import 'driver_routes_tab.dart';
import 'driver_profile_tab.dart';

class DriverHomePage extends StatefulWidget {
const DriverHomePage({super.key});

@override
State<DriverHomePage> createState() =>
_DriverHomePageState();
}

class _DriverHomePageState
extends State<DriverHomePage> {

  int selectedIndex = 0;

  final List<Widget> pages = const [

    DriverHomeTab(),

    DriverTripsTab(),

    DriverRoutesTab(),

    DriverProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: pages[selectedIndex],

      bottomNavigationBar:
      BottomNavigationBar(

        currentIndex:
        selectedIndex,

        type:
        BottomNavigationBarType.fixed,

        onTap: (index) {
          setState(() {
            selectedIndex =
                index;
          });
        },

        items: const [

          BottomNavigationBarItem(

            icon:
            Icon(Icons.home),

            label:
            "Home",
          ),

          BottomNavigationBarItem(

            icon:
            Icon(Icons.directions_bus),

            label:
            "Trips",
          ),

          BottomNavigationBarItem(

            icon:
            Icon(Icons.route),

            label:
            "Routes",
          ),

          BottomNavigationBarItem(

            icon:
            Icon(Icons.person),

            label:
            "Profile",
          ),
        ],
      ),
    );
  }
}