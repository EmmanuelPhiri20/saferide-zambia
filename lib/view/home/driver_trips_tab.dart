import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverTripsTab extends StatefulWidget {
const DriverTripsTab({
super.key,
});

@override
State<DriverTripsTab> createState() =>
_DriverTripsTabState();
}

class _DriverTripsTabState
extends State<DriverTripsTab> {


@override
Widget build(BuildContext context) {

return Scaffold(

appBar: AppBar(

title: const Text(
"Trips",
),

centerTitle: true,
),

body: Padding(

padding:
const EdgeInsets.all(20),

child: Column(

crossAxisAlignment:
CrossAxisAlignment.stretch,

children: [

// ACTIVE TRIP CARD

  Card(

    elevation: 5,

    child: Padding(

      padding:
      const EdgeInsets.all(15),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          const Text(

            "Current Trip",

            style: TextStyle(

              fontSize: 18,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          StreamBuilder<QuerySnapshot>(

            stream:
            FirebaseFirestore.instance
                .collection(
                'trip_requests')
                .where(

              'driverUid',

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

            builder:
                (context, snapshot) {

              if (!snapshot.hasData) {

                return const Center(

                  child:
                  CircularProgressIndicator(),
                );
              }

              if (snapshot
                  .data!
                  .docs
                  .isEmpty) {

                return const Text(
                  "No Active Trips",
                );
              }

              final trip =
              snapshot
                  .data!
                  .docs
                  .first
                  .data()
              as Map<String,
                  dynamic>;

              return Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(

                    "Passenger: ${trip['passengerName']}",
                  ),

                  Text(

                    "Pickup: ${trip['pickupLocation']}",
                  ),

                  Text(

                    "Destination: ${trip['destination']}",
                  ),

                  const Text(

                    "Status: Accepted",
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ),
  ),

const SizedBox(
height: 20,
),

  Card(

    elevation: 4,

    child: Padding(

      padding:
      const EdgeInsets.all(15),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          const Text(

            "Trip Requests",

            style: TextStyle(

              fontSize: 18,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          StreamBuilder<QuerySnapshot>(

            stream: FirebaseFirestore.instance
                .collection('trip_requests')
                .where(
              'driverUid',
              isEqualTo:
              FirebaseAuth.instance
                  .currentUser!
                  .uid,
            )
                .where(
              'status',
              isEqualTo:
              'pending',
            )
                .snapshots(),

            builder:
                (context, snapshot) {

              if (!snapshot.hasData) {

                return const Center(

                  child:
                  CircularProgressIndicator(),
                );
              }

              if (snapshot
                  .data!
                  .docs
                  .isEmpty) {

                return const Text(
                  "No pending requests.",
                );
              }

              return Column(

                children:
                snapshot.data!.docs
                    .map((doc) {

                  final request =
                  doc.data()
                  as Map<String,
                      dynamic>;

                  return Card(

                    margin:
                    const EdgeInsets.only(
                      bottom: 10,
                    ),

                    child: Padding(

                      padding:
                      const EdgeInsets.all(
                          12),

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          Text(

                            request[
                            'passengerName'],

                            style:
                            const TextStyle(

                              fontSize: 16,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Text(
                            "Pickup: ${request['pickupLocation']}",
                          ),

                          Text(
                            "Destination: ${request['destination']}",
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Row(

                            children: [

                              Expanded(

                                child:
                                ElevatedButton(

                                  onPressed:
                                      () async {

                                        await FirebaseFirestore.instance
                                            .collection('trip_requests')
                                            .doc(doc.id)
                                            .update({

                                          'status':
                                          'accepted',

                                          'acceptedAt':
                                          FieldValue.serverTimestamp(),
                                        });

                                    ScaffoldMessenger.of(
                                        context)
                                        .showSnackBar(

                                      const SnackBar(

                                        content: Text(
                                          "Request accepted",
                                        ),
                                      ),
                                    );
                                  },

                                  child:
                                  const Text(
                                    "Accept",
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              Expanded(

                                child:
                                ElevatedButton(

                                  onPressed:
                                      () async {

                                    await FirebaseFirestore
                                        .instance
                                        .collection(
                                        'trip_requests')
                                        .doc(
                                        doc.id)
                                        .update({

                                      'status':
                                      'rejected',
                                    });

                                    ScaffoldMessenger.of(
                                        context)
                                        .showSnackBar(

                                      const SnackBar(

                                        content: Text(
                                          "Request rejected",
                                        ),
                                      ),
                                    );
                                  },

                                  child:
                                  const Text(
                                    "Reject",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    ),
  ),

const SizedBox(
height: 20,
),

// TRIP HISTORY

Expanded(

child: Card(

elevation: 4,

child: Padding(

padding:
const EdgeInsets.all(15),

child: Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children: [

const Text(

"Trip History",

style: TextStyle(

fontSize: 18,

fontWeight:
FontWeight.bold,
),
),

const SizedBox(
height: 15,
),

  Expanded(

    child:
    StreamBuilder<QuerySnapshot>(

      stream:
      FirebaseFirestore.instance
          .collection('trip_requests')
          .where(
        'driverUid',
        isEqualTo:
        FirebaseAuth.instance
            .currentUser!
            .uid,
      )
          .snapshots(),

      builder:
          (context, snapshot) {

        if (!snapshot.hasData) {

          return const Center(

            child:
            CircularProgressIndicator(),
          );
        }

        return ListView.builder(

          itemCount:
          snapshot.data!.docs.length,

          itemBuilder:
              (context, index) {

            final trip =
            snapshot
                .data!
                .docs[index]
                .data()
            as Map<String,
                dynamic>;

            return ListTile(

              leading:
              const Icon(
                Icons.history,
              ),

              title: Text(

                "${trip['pickupLocation']} → ${trip['destination']}",
              ),

              subtitle: Text(
                "Passenger: ${trip['passengerName']} • ${trip['status']}",
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
),
],
),
),
);
}
}

