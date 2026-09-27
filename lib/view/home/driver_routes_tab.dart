import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DriverRoutesTab extends StatefulWidget {
  const DriverRoutesTab({
    super.key,
  });

  @override
  State<DriverRoutesTab> createState() =>
      _DriverRoutesTabState();
}

class _DriverRoutesTabState
    extends State<DriverRoutesTab> {

  String pickupLocation =
      "City Market Bus Station";

  String destination =
      "Chelstone";

  final TextEditingController
  seatController =
  TextEditingController(
    text: "14",
  );

  final TextEditingController
  fareController =
  TextEditingController();

  final List<String>
  pickupLocations = [

    // BUS STATIONS

    "City Market Bus Station",
    "Millennium Bus Station",
    "Kulima Tower Bus Station",
    "Lumumba Bus Station",
    "Kaunda Square Bus Station",
    "Kabwata Site & Service",

    // BUS STOPS

    "Longacres Bus Stop",
    "Civic Centre Bus Stop",
    "Levy Mall Bus Stop",
    "Kamwala Bus Stop",
    "Manda Hill Bus Stop",
    "Marshlands Bus Stop",
    "Munali Bus Stop",
    "Hybrid Bus Stop",
  ];

  final List<String>
  destinations = [

    "Chelstone",
    "Garden",
    "Matero",
    "Chilenje",
    "Kanyama",
    "Kabwata",
    "Woodlands",
    "Makeni",
    "Chalala",
    "Garden House",
    "Kabulonga",
    "Kabanana",
    "Ng'ombe",
    "Mandevu",
    "Kamwala",
    "Kamwala South",
    "Libala",
    "Chazanga",
  ];

  // =========================
  // SAVE ROUTE
  // =========================

  Future<void> saveRoute() async {

    try {

      final user =
          FirebaseAuth.instance.currentUser;

      if (user == null) return;

      // GET DRIVER DATA

      final driverDoc =
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final driverData =
      driverDoc.data();

      await FirebaseFirestore.instance
          .collection('active_routes')
          .doc(user.uid)
          .set({

        'driverUid':
        user.uid,

        'driverName':
        driverData?['fullName'] ?? "",

        'vehicleType':
        driverData?['vehicleType'] ?? "",

        'vehiclePlateNumber':
        driverData?['vehiclePlateNumber']
            ?? "",

        'pickupLocation':
        pickupLocation,

        'destination':
        destination,

        'availableSeats':
        int.tryParse(
          seatController.text,
        ) ?? 14,

        'fare':
        int.tryParse(
          fareController.text,
        ) ?? 0,

        'onlineStatus':
        true,

        'timestamp':
        FieldValue.serverTimestamp(),
      });

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content: Text(
              "Route Published Successfully",
            ),
          ),
        );
      }

    } catch (e) {

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(
            content:
            Text(
              e.toString(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Routes",
        ),

        centerTitle: true,
      ),

      body: Padding(

        padding:
        const EdgeInsets.all(20),

        child: SingleChildScrollView(

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.stretch,

            children: [

              // PICKUP LOCATION

              DropdownButtonFormField<
                  String>(

                value:
                pickupLocation,

                decoration:
                const InputDecoration(

                  labelText:
                  "Pickup Location",

                  border:
                  OutlineInputBorder(),
                ),

                items:
                pickupLocations.map(
                      (location) {

                    return DropdownMenuItem(

                      value:
                      location,

                      child:
                      Text(
                        location,
                      ),
                    );
                  },
                ).toList(),

                onChanged:
                    (value) {

                  setState(() {

                    pickupLocation =
                    value!;
                  });
                },
              ),

              const SizedBox(
                height: 20,
              ),

              // DESTINATION

              DropdownButtonFormField<
                  String>(

                value:
                destination,

                decoration:
                const InputDecoration(

                  labelText:
                  "Destination",

                  border:
                  OutlineInputBorder(),
                ),

                items:
                destinations.map(
                      (area) {

                    return DropdownMenuItem(

                      value:
                      area,

                      child:
                      Text(
                        area,
                      ),
                    );
                  },
                ).toList(),

                onChanged:
                    (value) {

                  setState(() {

                    destination =
                    value!;
                  });
                },
              ),

              const SizedBox(
                height: 20,
              ),

              // AVAILABLE SEATS

              TextField(

                controller:
                seatController,

                keyboardType:
                TextInputType.number,

                decoration:
                const InputDecoration(

                  labelText:
                  "Available Seats",

                  border:
                  OutlineInputBorder(),
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              Text(
                "Fare: K${fareController.text}",
              ),

              TextField(

                controller:
                fareController,

                keyboardType:
                TextInputType.number,

                decoration:
                const InputDecoration(

                  labelText:
                  "Fare (ZMW)",

                  border:
                  OutlineInputBorder(),
                ),
              ),

              // ROUTE SUMMARY

              Card(

                elevation: 4,

                child: Padding(

                  padding:
                  const EdgeInsets
                      .all(15),

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      const Text(

                        "Current Route",

                        style:
                        TextStyle(

                          fontSize: 18,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(
                        "Pickup: $pickupLocation",
                      ),

                      Text(
                        "Destination: $destination",
                      ),

                      Text(
                        "Seats: ${seatController.text}",
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              ElevatedButton.icon(

                onPressed:
                saveRoute,

                icon:
                const Icon(
                  Icons.save,
                ),

                label:
                const Text(
                  "Publish Route",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}