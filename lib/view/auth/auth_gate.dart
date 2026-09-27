
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../home/home_page_passenger.dart';
import '../home/home_page_driver.dart';
import '../home/home_page_admin.dart';

import '../profile/complete_passenger_profile.dart';
import '../profile/complete_driver_profile.dart';

import 'login_page.dart';

class AuthGate extends StatelessWidget {

  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(

      stream:
      FirebaseAuth.instance
          .authStateChanges(),

      builder: (context, snapshot) {
// LOADING
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Scaffold(

            body: Center(
              child:
              CircularProgressIndicator(),
            ),
          );
        }

// USER LOGGED IN
        if (snapshot.hasData) {
          final user = snapshot.data!;

          return FutureBuilder<DocumentSnapshot>(

            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get(),

            builder:
                (context, userSnapshot) {
// LOADING
              if (userSnapshot
                  .connectionState ==
                  ConnectionState.waiting) {
                return const Scaffold(

                  body: Center(
                    child:
                    CircularProgressIndicator(),
                  ),
                );
              }

// NO USER DATA
              if (!userSnapshot.hasData ||
                  !userSnapshot.data!.exists) {
                return const Scaffold(

                  body: Center(
                    child:
                    Text("User data not found"),
                  ),
                );
              }

// USER DATA
                  final userData =
                  userSnapshot.data!.data()
                  as Map<String, dynamic>;


// GET ROLE
              final role =
              userData['role'];

// GET PROFILE STATUS
              final profileCompleted =
                  userData['profileCompleted']
                      ?? false;

// =========================
// PROFILE NOT COMPLETED
// =========================

              if (!profileCompleted) {
// PASSENGER PROFILE
                if (role == 'passenger') {
                  return const
                  CompletePassengerProfilePage();
                }

// DRIVER PROFILE
                else if (role == 'driver') {
                  return const
                  CompleteDriverProfilePage();
                }
              }

// =========================
// PROFILE COMPLETED
// =========================

// PASSENGER
              if (role == 'passenger') {
                return const
                PassengerHomePage();
              }

// DRIVER
              else if (role == 'driver') {
                return const
                DriverHomePage();
              }

// ADMIN
              else if (role == 'admin') {
                return const
                AdminHomePage();
              }

// UNKNOWN ROLE
              else {
                return const Scaffold(

                  body: Center(
                    child:
                    Text("Unknown Role"),
                  ),
                );
              }
            },
          );
        }

// USER NOT LOGGED IN
        return const LoginPage();
      },
    );
  }
}