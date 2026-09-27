
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/auth_gate.dart';



class CompletePassengerProfilePage
extends StatefulWidget {

const CompletePassengerProfilePage({
super.key,
});

@override
State<CompletePassengerProfilePage>
createState() =>
_CompletePassengerProfilePageState();
}

class _CompletePassengerProfilePageState
extends State<
CompletePassengerProfilePage> {

  final TextEditingController
  addressController =
  TextEditingController();

  final TextEditingController
  emergencyContactController =
  TextEditingController();

  bool isLoading = false;

// =========================
// SAVE PROFILE
// =========================

  Future<void> saveProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user =
          FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({

        'address':
        addressController.text.trim(),

        'emergencyContact':
        emergencyContactController.text
            .trim(),

        'profileCompleted': true,
      });

// SUCCESS MESSAGE
    ScaffoldMessenger.of(context)
        .showSnackBar(

    const SnackBar(
    content:
    Text("Profile Completed"),
    ),
    );

// REFRESH AUTH GATE
    Navigator.pushAndRemoveUntil(

    context,

    MaterialPageRoute(
    builder: (_) => const AuthGate(),
    ),

    (route) => false,
    );

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: const Text(
            ""),
      ),

      body: Padding(

        padding:
        const EdgeInsets.all(20),

        child: SingleChildScrollView(

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.stretch,

            children: [

              const SizedBox(height: 20),

              const Text(

                "Complete Your Profile",

                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

// ADDRESS
              TextField(

                controller:
                addressController,

                decoration:
                const InputDecoration(

                  labelText: "Address",

                  border:
                  OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

// EMERGENCY CONTACT
              TextField(

                controller:
                emergencyContactController,

                keyboardType:
                TextInputType.phone,

                decoration:
                const InputDecoration(

                  labelText:
                  "Emergency Contact",

                  border:
                  OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

// SAVE BUTTON
              ElevatedButton(

                onPressed:
                isLoading
                    ? null
                    : saveProfile,

                child:
                isLoading

                    ? const
                CircularProgressIndicator()

                    : const Text(
                    "Save Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
