import '../../core/theme/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../maps/passenger_map.dart';

class PassengerHomePage
extends StatefulWidget {

const PassengerHomePage({
super.key,
});

@override
State<PassengerHomePage>
createState() =>
_PassengerHomePageState();
}

class _PassengerHomePageState
extends State<
PassengerHomePage> {

  int currentIndex = 0;

  final TextEditingController
  sosController =
  TextEditingController();

  String selectedDestination =
      "Chelstone";

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
// LOGOUT
// =========================

  Future<void> logout() async {
    await FirebaseAuth.instance
        .signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(

      appBar: AppBar(

        title:
        const Text(
            "SafeRide Zambia"),

        centerTitle: true,

        actions: [

          IconButton(

            onPressed: logout,

            icon:
            const Icon(Icons.logout),
          ),
        ],
      ),

      body: IndexedStack(

        index: currentIndex,

        children: [

// =====================
// HOME TAB
// =====================

          SingleChildScrollView(

            padding:
            const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

// WELCOME

                Container(

                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  decoration: const BoxDecoration(

                    color: AppColors.primaryGreen,

                    borderRadius: BorderRadius.only(

                      bottomLeft:
                      Radius.circular(30),

                      bottomRight:
                      Radius.circular(30),
                    ),
                  ),

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      const SizedBox(height: 20),

                      const Text(

                        "GOOD MORNING",

                        style: TextStyle(

                          color: Colors.white70,

                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(

                        "Find Your Ride",

                        style: TextStyle(

                          color: Colors.white,

                          fontSize: 28,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(

                        "Safe, verified minibuses across Lusaka",

                        style: TextStyle(

                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 20),

                      FutureBuilder(

                        future:
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user!.uid)
                            .get(),

                        builder:
                            (context, snapshot) {

                          if (!snapshot.hasData) {

                            return const SizedBox();
                          }

                          final userData =
                          snapshot.data!;

                          return Text(

                            "Welcome ${userData['fullName']}",

                            style:
                            const TextStyle(

                              color:
                              Colors.white,
                              fontSize:26,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

    SizedBox(

    height: 250,

    child: ClipRRect(

    borderRadius:
    BorderRadius.circular(20),

    child: const PassengerMap(),
    ),
    ),

                const SizedBox(height: 20),

                InkWell(

                  onTap: () {

                    setState(() {

                      currentIndex = 1;
                    });
                  },

                  child: Container(

                    padding:
                    const EdgeInsets.all(18),

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(15),

                      boxShadow: [

                        BoxShadow(

                          color:
                          Colors.black12,

                          blurRadius: 5,
                        ),
                      ],
                    ),

                    child: const Row(

                      children: [

                        Icon(
                          Icons.search,
                          size: 30,
                        ),

                        SizedBox(width: 15),

                        Expanded(

                          child: Text(
                            "Where are you going?" "",

                            style: TextStyle(

                              fontSize: 18,

                              fontWeight:
                              FontWeight.w500,
                            ),
                          ),
                        ),

                        Icon(
                          Icons.arrow_forward_ios,
                        ),
                      ],
                    ),
                  ),
                ),


// NEARBY VEHICLES

                const SizedBox(height: 20),

                buildVehicleCard(
                  "Drivers currently online will appear here.",
                  "",
                  "",
                ),

              ],
            ),
          ),

// =====================
// TRACK TAB
// =====================

          SingleChildScrollView(

            padding: const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const Text(

                  "Where are you going?",

                  style: TextStyle(

                    fontSize: 24,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),


                Row(

                  children: [

                    Expanded(

                      child:
                      DropdownButtonFormField<String>(

                        value:
                        selectedDestination,

                        decoration:
                        InputDecoration(

                          labelText:
                          "Destination",

                          border:
                          OutlineInputBorder(

                            borderRadius:
                            BorderRadius.circular(15),
                          ),
                        ),

                        items:
                        destinations.map(

                              (destination) {

                            return DropdownMenuItem(

                              value:
                              destination,

                              child:
                              Text(destination),
                            );
                          },
                        ).toList(),

                        onChanged:
                            (value) {

                          setState(() {

                            selectedDestination =
                            value!;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    Container(

                      height: 58,

                      width: 58,

                      decoration:
                      BoxDecoration(

                        color:
                        Colors.green,

                        borderRadius:
                        BorderRadius.circular(15),
                      ),

                      child:
                      IconButton(

                        icon:
                        const Icon(

                          Icons.search,

                          color:
                          Colors.white,
                        ),

                        onPressed: () {

                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                
                SizedBox(

                  height: 285,

                  child: ClipRRect(

                    borderRadius:
                    BorderRadius.circular(20),

                    child:
                    const PassengerMap(),
                  ),
                ),

                const SizedBox(height: 2),

                SizedBox(

                  width: double.infinity,

                  child: Card(

                    child: Padding(

                      padding: const EdgeInsets.all(15),

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          const Text(
                            "Selected Destination",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(selectedDestination),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),


                StreamBuilder<QuerySnapshot>(

                  stream: FirebaseFirestore.instance
                      .collection('trip_requests')
                      .where(
                    'passengerUid',
                    isEqualTo:
                    FirebaseAuth.instance
                        .currentUser!
                        .uid,
                  )
                      .where(
                    'status',
                    isEqualTo:
                    'accepted',
                  )
                      .snapshots(),

                  builder: (context, snapshot) {

                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {

                      return const SizedBox();
                    }

                    final trip =
                    snapshot.data!.docs.first.data()
                    as Map<String, dynamic>;

                    return SizedBox(

                      width: double.infinity,

                      child: Card(

                      color: Colors.green.shade50,

                      child: Padding(

                        padding:
                        const EdgeInsets.all(15),

                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.center,

                          children: [

                            const Icon(

                              Icons.check_circle,

                              color: Colors.green,

                              size: 50,
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            const Text(

                              "Driver Accepted Your Request",

                              textAlign: TextAlign.center,

                              style: TextStyle(

                                fontSize: 18,

                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            Text(

                              "Driver: ${trip['driverName']}",

                              textAlign: TextAlign.center,
                            ),

                            Text(

                              "Pickup: ${trip['pickupLocation']}",

                              textAlign: TextAlign.center,
                            ),

                            Text(

                              "Destination: ${trip['destination']}",

                              textAlign: TextAlign.center,
                            ),

                            Text(

                              "Status: ${trip['status']}",

                              textAlign: TextAlign.center,

                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            const Text(

                              "Rate Driver",

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Row(

                              mainAxisAlignment:
                              MainAxisAlignment.center,

                              children: List.generate(

                                5,

                                    (index) {

                                  return IconButton(

                                    icon: const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),

                                    onPressed: () async {

                                      await FirebaseFirestore
                                          .instance
                                          .collection('reviews')
                                          .add({

                                        'driverUid':
                                        trip['driverUid'],

                                        'passengerUid':
                                        FirebaseAuth.instance
                                            .currentUser!
                                            .uid,

                                        'rating':
                                        index + 1,

                                        'timestamp':
                                        FieldValue.serverTimestamp(),
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(

                                        SnackBar(

                                          content: Text(
                                            "${index + 1} Star Rating Submitted",
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      ),
                    );
                  },
                ),

                const SizedBox(
                  height: 15,
                ),

                StreamBuilder<QuerySnapshot>(

                  stream: FirebaseFirestore.instance
                      .collection('trip_requests')
                      .where(
                    'passengerUid',
                    isEqualTo:
                    FirebaseAuth.instance.currentUser!.uid,
                  )
                      .snapshots(),

                  builder: (context, requestSnapshot) {

                    if (!requestSnapshot.hasData) {

                      return const SizedBox();
                    }

                    // Hide driver list if passenger already
                    // has pending or accepted request

                    if (requestSnapshot.data!.docs.isNotEmpty) {

                      return const SizedBox();
                    }

                    return FutureBuilder<QuerySnapshot>(

                      future: FirebaseFirestore.instance
                          .collection('active_routes')
                          .get(),

                      builder: (context, snapshot) {

                        if (!snapshot.hasData) {

                          return const Center(
                            child:
                            CircularProgressIndicator(),
                          );
                        }

                        return ListView.builder(

                          shrinkWrap: true,

                          physics:
                          const NeverScrollableScrollPhysics(),

                          itemCount:
                          snapshot.data!.docs.length,

                          itemBuilder:
                              (context, index) {

                            final data =
                            snapshot.data!.docs[index]
                                .data()
                            as Map<String, dynamic>;

                            return Card(

                              margin:
                              const EdgeInsets.only(
                                bottom: 15,
                              ),

                              child: Padding(

                                padding:
                                const EdgeInsets.all(15),

                                child: Column(

                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,

                                  children: [

                                    Text(

                                      data['driverName'],

                                      style:
                                      const TextStyle(

                                        fontSize: 18,

                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    Text(
                                      "Vehicle: ${data['vehicleType']}",
                                    ),

                                    Text(
                                      "Plate: ${data['vehiclePlateNumber']}",
                                    ),

                                    Text(
                                      "Pickup: ${data['pickupLocation']}",
                                    ),

                                    Text(
                                      "Fare: K${data['fare'] ?? 0}",
                                    ),

                                    Text(
                                      "Seats: ${data['availableSeats']}",
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    ElevatedButton(

                                      onPressed: () async {

                                        final passenger =
                                            FirebaseAuth
                                                .instance
                                                .currentUser;

                                        final passengerDoc =
                                        await FirebaseFirestore
                                            .instance
                                            .collection('users')
                                            .doc(passenger!.uid)
                                            .get();

                                        await FirebaseFirestore
                                            .instance
                                            .collection(
                                            'trip_requests')
                                            .add({

                                          'passengerUid':
                                          passenger.uid,

                                          'passengerName':
                                          passengerDoc[
                                          'fullName'],

                                          'driverUid':
                                          data['driverUid'],

                                          'driverName':
                                          data['driverName'],

                                          'pickupLocation':
                                          data['pickupLocation'],

                                          'destination':
                                          data['destination'],

                                          'status':
                                          'pending',

                                          'timestamp':
                                          FieldValue
                                              .serverTimestamp(),
                                        });

                                        ScaffoldMessenger.of(
                                            context)
                                            .showSnackBar(

                                          const SnackBar(

                                            content: Text(
                                              "Seat request sent",
                                            ),
                                          ),
                                        );
                                      },

                                      child:
                                      const Text(
                                        "Request Seat",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

// =====================
// SOS TAB
// =====================

          Padding(

            padding: const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.stretch,

              children: [

                const Text(

                  "Emergency SOS",

                  style: TextStyle(

                    fontSize: 24,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(

                  "Send an emergency report to the SafeRide administrator.",
                ),

                const SizedBox(height: 20),

                TextField(

                  controller:
                  sosController,

                  maxLines: 5,

                  decoration:
                  const InputDecoration(

                    labelText:
                    "Describe the emergency",

                    border:
                    OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(

                  icon: const Icon(
                    Icons.warning,
                  ),

                  label: const Text(
                    "Send SOS Report",
                  ),

                  onPressed: () async {

                    final passenger =
                        FirebaseAuth.instance
                            .currentUser;

                    final userDoc =
                    await FirebaseFirestore
                        .instance
                        .collection('users')
                        .doc(passenger!.uid)
                        .get();

                    await FirebaseFirestore
                        .instance
                        .collection(
                        'sos_reports')
                        .add({

                      'passengerUid':
                      passenger.uid,

                      'passengerName':
                      userDoc['fullName'],

                      'message':
                      sosController.text,

                      'status':
                      'pending',

                      'timestamp':
                      FieldValue
                          .serverTimestamp(),
                    });

                    sosController.clear();

                    ScaffoldMessenger.of(
                        context)
                        .showSnackBar(

                      const SnackBar(

                        content: Text(
                          "SOS Report Sent",
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
// =====================
// HISTORY TAB
// =====================

          StreamBuilder<QuerySnapshot>(

            stream: FirebaseFirestore.instance
                .collection('trip_requests')
                .where(
              'passengerUid',
              isEqualTo:
              FirebaseAuth.instance
                  .currentUser!
                  .uid,
            )
               .snapshots(),

            builder: (context, snapshot) {

              if (snapshot.connectionState ==
                  ConnectionState.waiting) {

                return const Center(
                  child:
                  CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData) {

                return const Center(
                  child: Text(
                    "No Trip History",
                  ),
                );
              }

              if (snapshot.data!.docs.isEmpty) {

                return const Center(

                  child: Text(
                    "No Trip History",
                  ),
                );
              }

              return ListView.builder(

                itemCount:
                snapshot.data!.docs.length,

                itemBuilder: (context, index) {

                  final data =
                  snapshot.data!.docs[index].data()
                  as Map<String, dynamic>;

                  return Card(

                    margin:
                    const EdgeInsets.all(10),

                    child: ListTile(

                      leading: const Icon(
                        Icons.history,
                      ),

                      title: Text(
                        data['destination'],
                      ),

                      subtitle: Text(
                        "Driver: ${data['driverName']}",
                      ),

                      trailing: Text(
                        data['status'],
                      ),
                    ),
                  );
                },
              );
            },
          ),

// =====================
// PROFILE TAB
// =====================

    FutureBuilder<DocumentSnapshot>(

    future: FirebaseFirestore.instance
        .collection('users')
        .doc(
    FirebaseAuth.instance
        .currentUser!
        .uid,
    )
        .get(),

    builder: (context, snapshot) {

    if (!snapshot.hasData) {

    return const Center(
    child:
    CircularProgressIndicator(),
    );
    }

    final userData =
    snapshot.data!.data()
    as Map<String, dynamic>;

    return SingleChildScrollView(

    padding:
    const EdgeInsets.all(20),

    child: Column(

    children: [

    const CircleAvatar(

    radius: 50,

    child: Icon(
    Icons.person,
    size: 50,
    ),
    ),

    const SizedBox(height: 20),

    Card(

    child: ListTile(

    leading:
    const Icon(Icons.person),

    title: const Text(
    "Full Name",
    ),

    subtitle: Text(
    userData['fullName']
    ?? '',
    ),
    ),
    ),

    Card(

    child: ListTile(

    leading:
    const Icon(Icons.email),

    title:
    const Text("Email"),

    subtitle: Text(
    userData['email']
    ?? '',
    ),
    ),
    ),

    Card(

    child: ListTile(

    leading:
    const Icon(Icons.phone),

    title:
    const Text("Phone"),

    subtitle: Text(
    userData['phone']
    ?? '',
    ),
    ),
    ),

    Card(

    child: ListTile(

    leading:
    const Icon(Icons.shield),

    title: const Text(
    "Emergency Contact",
    ),

    subtitle: Text(
    userData[
    'emergencyContact'
    ] ??
    'Not Set',
    ),
    ),
    ),

    const SizedBox(height: 20),

    ElevatedButton.icon(

    onPressed: logout,

    icon: const Icon(
    Icons.logout,
    ),

    label: const Text(
    "Logout",
    ),
    ),
    ],
    ),
    );
    },
    ),
    ]
    ),

// =========================
// BOTTOM NAVIGATION
// =========================

      bottomNavigationBar:
      BottomNavigationBar(

        currentIndex: currentIndex,

        selectedItemColor:
        Colors.green,

        unselectedItemColor:
        Colors.grey,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [

          BottomNavigationBarItem(

            icon: Icon(Icons.home),

            label: "Home",
          ),

          BottomNavigationBarItem(

            icon:
            Icon(Icons.location_on),

            label: "Track",
          ),

          BottomNavigationBarItem(

            icon:
            Icon(Icons.emergency),

            label: "SOS",
          ),

          BottomNavigationBarItem(

            icon:
            Icon(Icons.history),

            label: "History",
          ),

          BottomNavigationBarItem(

            icon:
            Icon(Icons.person),

            label: "Profile",
          ),
        ],
      ),
    );
  }

// =========================
// STATION MARKER
// =========================

  Widget buildStationMarker(String name) {
    return Column(

      children: [

        const Icon(

          Icons.location_pin,

          color: Colors.red,

          size: 35,
        ),

        Container(

          padding:
          const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius:
            BorderRadius.circular(10),
          ),

          child: Text(name),
        ),
      ],
    );
  }

// =========================
// VEHICLE CARD
// =========================

  Widget buildVehicleCard(String vehicle,

      String route,

      String distance,) {
    return Card(

      margin:
      const EdgeInsets.only(bottom: 15),

      child: ListTile(

        leading: const CircleAvatar(

          child:
          Icon(Icons.directions_bus),
        ),

        title: Text(vehicle),

        subtitle: Text(route),

        trailing: Text(distance),
      ),
    );
  }
}