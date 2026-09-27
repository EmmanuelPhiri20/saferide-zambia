import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../maps/driver_map.dart';

class DriverHomeTab extends StatefulWidget {
const DriverHomeTab({
super.key,
});

@override
State<DriverHomeTab> createState() =>
_DriverHomeTabState();
}

class _DriverHomeTabState
extends State<DriverHomeTab> {

  bool isOnline = false;

  @override
  Widget build(BuildContext context) {
    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Driver Dashboard",
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

// DRIVER CARD

              Card(

                elevation: 5,

                child: Padding(

                  padding:
                  const EdgeInsets.all(20),

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      const Text(

                        "Welcome Driver",

                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      FutureBuilder<
                          DocumentSnapshot>(

                        future:
                        FirebaseFirestore
                            .instance
                            .collection(
                            'users')
                            .doc(
                            user?.uid)
                            .get(),

                        builder:
                            (context,
                            snapshot) {
                          if (!snapshot
                              .hasData) {
                            return const Text(

                              "Loading...",

                              style:
                              TextStyle(

                                fontSize:
                                22,

                                fontWeight:
                                FontWeight
                                    .bold,
                              ),
                            );
                          }

                          final data =
                          snapshot
                              .data!
                              .data()
                          as Map<
                              String,
                              dynamic>;

                          return Text(

                            data['fullName']
                                ??
                                "Driver",

                            style:
                            const TextStyle(

                              fontSize:
                              22,

                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          );
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Row(

                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                        children: [

                          Text(

                            isOnline
                                ? "Online"
                                : "Offline",

                            style:
                            TextStyle(

                              fontSize:
                              18,

                              fontWeight:
                              FontWeight
                                  .bold,

                              color:
                              isOnline
                                  ? Colors
                                  .green
                                  : Colors
                                  .red,
                            ),
                          ),

                          Switch(

                            value:
                            isOnline,

                            onChanged:
                                (value) {
                              setState(() {
                                isOnline =
                                    value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

// DRIVER MAP

              SizedBox(

                height: 300,

                child: ClipRRect(

                  borderRadius:
                  BorderRadius
                      .circular(
                      20),

                  child:
                  const DriverMap(),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

// STATUS CARD

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

                        "Driver Status",

                        style:
                        TextStyle(

                          fontSize:
                          18,

                          fontWeight:
                          FontWeight
                              .bold,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(

                        isOnline

                            ? "You are currently visible to passengers."

                            : "You are currently offline.",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
