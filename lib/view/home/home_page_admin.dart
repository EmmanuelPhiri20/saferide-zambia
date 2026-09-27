import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
        ),
        actions: [

          IconButton(

            onPressed: () async {

              await FirebaseAuth.instance.signOut();
            },

            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            // USERS

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .snapshots(),

              builder: (context, snapshot) {

                int totalUsers =
                    snapshot.data?.docs.length ?? 0;

                return _buildCard(
                  "Total Users",
                  totalUsers.toString(),
                  Icons.people,
                );
              },
            ),

            const SizedBox(height: 10),

            // DRIVERS

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                'role',
                isEqualTo: 'driver',
              )
                  .snapshots(),

              builder: (context, snapshot) {

                int drivers =
                    snapshot.data?.docs.length ?? 0;

                return _buildCard(
                  "Drivers",
                  drivers.toString(),
                  Icons.directions_bus,
                );
              },
            ),

            const SizedBox(height: 10),

            // PASSENGERS

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                'role',
                isEqualTo: 'passenger',
              )
                  .snapshots(),

              builder: (context, snapshot) {

                int passengers =
                    snapshot.data?.docs.length ?? 0;

                return _buildCard(
                  "Passengers",
                  passengers.toString(),
                  Icons.person,
                );
              },
            ),

            const SizedBox(height: 10),

            // ACTIVE ROUTES

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('active_routes')
                  .snapshots(),

              builder: (context, snapshot) {

                int routes =
                    snapshot.data?.docs.length ?? 0;

                return _buildCard(
                  "Active Routes",
                  routes.toString(),
                  Icons.route,
                );
              },
            ),

            const SizedBox(height: 10),

            // TRIP REQUESTS

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('trip_requests')
                  .snapshots(),

              builder: (context, snapshot) {

                int requests =
                    snapshot.data?.docs.length ?? 0;

                return _buildCard(
                  "Trip Requests",
                  requests.toString(),
                  Icons.request_page,
                );
              },
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Driver Verification",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "SOS Reports",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            StreamBuilder<QuerySnapshot>(

              stream: FirebaseFirestore.instance
                  .collection('sos_reports')
                  .orderBy(
                'timestamp',
                descending: true,
              )
                  .snapshots(),

              builder: (context, snapshot) {

                if (!snapshot.hasData) {

                  return const Center(
                    child:
                    CircularProgressIndicator(),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {

                  return const Card(

                    child: Padding(

                      padding:
                      EdgeInsets.all(15),

                      child: Text(
                        "No SOS Reports",
                      ),
                    ),
                  );
                }

                return Column(

                  children:

                  snapshot.data!.docs.map((doc) {

                    final data =
                    doc.data()
                    as Map<String, dynamic>;

                    return Card(

                      child: ListTile(

                        leading: const Icon(
                          Icons.warning,
                          color: Colors.red,
                        ),

                        title: Text(
                          data['passengerName']
                              ?? '',
                        ),

                        subtitle: Text(
                          data['message']
                              ?? '',
                        ),

                        trailing: Text(
                          data['status']
                              ?? '',
                        ),
                      ),
                    );

                  }).toList(),
                );
              },
            ),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                'role',
                isEqualTo: 'driver',
              )
                  .snapshots(),

              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                return Column(

                  children: snapshot.data!.docs.map((doc) {

                    final data =
                    doc.data()
                    as Map<String, dynamic>;

                    bool verified =
                        data['driverVerified']
                            ?? false;

                    return Card(

                      child: ListTile(

                        title: Text(
                          data['fullName']
                              ?? '',
                        ),

                        subtitle: Text(
                          verified
                              ? "Verified"
                              : "Pending Verification",
                        ),

                        trailing: verified
                            ? const Icon(
                          Icons.verified,
                          color: Colors.green,
                        )
                            : ElevatedButton(

                          onPressed: () async {

                            await FirebaseFirestore
                                .instance
                                .collection('users')
                                .doc(doc.id)
                                .update({

                              'driverVerified':
                              true,

                            });
                          },

                          child: const Text(
                            "Verify",
                          ),
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
    );
  }



  Widget _buildCard(
      String title,
      String value,
      IconData icon,
      ) {

    return Card(

      elevation: 4,

      child: ListTile(

        leading: Icon(icon),

        title: Text(title),

        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}