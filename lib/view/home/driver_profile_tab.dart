import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DriverProfileTab extends StatelessWidget {
  const DriverProfileTab({
    super.key,
  });

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Driver Profile",
        ),

        centerTitle: true,
      ),

      body: FutureBuilder<DocumentSnapshot>(

        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          final data =
          snapshot.data!.data()
          as Map<String, dynamic>;

          return SingleChildScrollView(

            padding:
            const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.stretch,

              children: [

                // PROFILE PHOTO

                CircleAvatar(

                  radius: 60,

                  child: Icon(

                    Icons.person,

                    size: 60,

                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                Center(

                  child: Text(

                    data['fullName'] ??
                        "Driver",

                    style: const TextStyle(

                      fontSize: 24,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                buildProfileTile(
                  "Phone Number",
                  data['phone'] ?? "",
                ),

                buildProfileTile(
                  "Email",
                  data['email'] ?? "",
                ),

                buildProfileTile(
                  "Date Of Birth",
                  data['dateOfBirth'] ?? "",
                ),

                buildProfileTile(
                  "NRC",
                  data['nrc'] ?? "",
                ),

                buildProfileTile(
                  "Driver License",
                  data['licenseNumber'] ?? "",
                ),

                buildProfileTile(
                  "Vehicle Type",
                  data['vehicleType'] ?? "",
                ),

                buildProfileTile(
                  "Plate Number",
                  data['vehiclePlateNumber'] ?? "",
                ),

                buildProfileTile(
                  "Emergency Contact",
                  data['emergencyContact'] ?? "",
                ),

                const SizedBox(
                  height: 20,
                ),

                Card(

                  color:
                  (data['driverVerified'] ??
                      false)

                      ? Colors.green.shade100

                      : Colors.orange.shade100,

                  child: Padding(

                    padding:
                    const EdgeInsets.all(15),

                    child: Row(

                      children: [

                        Icon(

                          (data['driverVerified']
                              ?? false)

                              ? Icons.verified

                              : Icons.pending,

                          color:

                          (data['driverVerified']
                              ?? false)

                              ? Colors.green

                              : Colors.orange,
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Text(

                          (data['driverVerified']
                              ?? false)

                              ? "Verified Driver"

                              : "Verification Pending",

                          style:
                          const TextStyle(

                            fontWeight:
                            FontWeight.bold,
                          ),
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

                      children: const [

                        Text(

                          "Driver Rating",

                          style: TextStyle(

                            fontSize: 18,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        Row(

                          children: [

                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),

                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),

                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),

                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),

                            Icon(
                              Icons.star_border,
                              color: Colors.amber,
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 5,
                        ),

                        Text(
                          "No reviews yet",
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                ElevatedButton.icon(

                  onPressed: () async {

                    await logout();

                    if (context.mounted) {

                      Navigator.pushNamedAndRemoveUntil(

                        context,

                        '/login',

                            (route) => false,
                      );
                    }
                  },

                  icon:
                  const Icon(
                    Icons.logout,
                  ),

                  label:
                  const Text(
                    "Logout",
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildProfileTile(
      String title,
      String value,
      ) {
    return Card(

      margin:
      const EdgeInsets.only(
        bottom: 10,
      ),

      child: ListTile(

        title:
        Text(title),

        subtitle:
        Text(value),
      ),
    );
  }
}