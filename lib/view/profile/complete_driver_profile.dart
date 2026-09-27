import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import '../auth/auth_gate.dart';



class CompleteDriverProfilePage
extends StatefulWidget {

const CompleteDriverProfilePage({
super.key,
});

@override
State<CompleteDriverProfilePage>
createState() =>
_CompleteDriverProfilePageState();
}

class _CompleteDriverProfilePageState
extends State<
CompleteDriverProfilePage> {

  final TextEditingController
  nrcController =
  TextEditingController();

  final TextEditingController
  licenseController =
  TextEditingController();

  final TextEditingController
  plateNumberController =
  TextEditingController();

  final TextEditingController
  vehicleTypeController =
  TextEditingController();

  final TextEditingController
  addressController =
  TextEditingController();

  final TextEditingController
  emergencyContactController =
  TextEditingController();

  final TextEditingController
  dobController =
  TextEditingController();

  bool isLoading = false;

  File? selectedImage;


// =========================
// OPEN PHONE CAMERA
// =========================

  Future<void> pickImage() async {

    try {

      final XFile? pickedFile =
      await ImagePicker().pickImage(

        source: ImageSource.camera,

        preferredCameraDevice:
        CameraDevice.front,

        imageQuality: 35,
      );

      // USER CANCELLED
      if (pickedFile == null) {
        return;
      }

      final File imageFile =
      File(pickedFile.path);

      // CHECK FILE SIZE
      final imageSize =
      await imageFile.length();

      // LIMIT 1MB
      if (imageSize > 1000000) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content: Text(
              "Image must be below 1MB",
            ),
          ),
        );

        return;
      }

      setState(() {

        selectedImage = imageFile;
      });

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            "Camera Error: $e",
          ),
        ),
      );
    }
  }


// =========================
// NRC FORMATTER
// =========================

  void formatNRC(String value) {
    value =
        value.replaceAll('/', '');

    if (value.length > 9) {
      value = value.substring(0, 9);
    }

    String formatted = '';

    for (int i = 0;
    i < value.length;
    i++) {
      formatted += value[i];

      if (i == 5 || i == 7) {
        formatted += '/';
      }
    }

    nrcController.value =
        TextEditingValue(

          text: formatted,

          selection:
          TextSelection.collapsed(
            offset: formatted.length,
          ),
        );
  }


// =========================
// DOB FORMATTER
// =========================

  void formatDOB(String value) {

    value =
        value.replaceAll('/', '');

    if (value.length > 8) {
      value = value.substring(0, 8);
    }

    String formatted = '';

    for (int i = 0;
    i < value.length;
    i++) {

      formatted += value[i];

      if (i == 1 || i == 3) {
        formatted += '/';
      }
    }

    dobController.value =
        TextEditingValue(

          text: formatted,

          selection:
          TextSelection.collapsed(
            offset: formatted.length,
          ),
        );
  }


// =========================
// SAVE DRIVER PROFILE
// =========================

  Future<void> saveDriverProfile() async {
    setState(() {
      isLoading = true;
    });


// REQUIRE DRIVER SELFIE
    if (selectedImage == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Driver selfie required",
          ),
        ),
      );

      setState(() {
        isLoading = false;
      });

      return;
    }


    try {
      final user =
          FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({

        'nrc':
        nrcController.text.trim(),

        'licenseNumber':
        licenseController.text.trim(),

        'vehiclePlateNumber':
        "${plateNumberController.text.trim()} ZM",

        'vehicleType':
        vehicleTypeController.text
            .trim(),

        'address':
        addressController.text.trim(),

        'emergencyContact':
        emergencyContactController.text
            .trim(),

        'dateOfBirth':
        dobController.text.trim(),

        'driverVerified': false,

        'profileCompleted': true,
      });


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
        title:
        const Text(
            "Complete Driver Profile"),
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


// DRIVER SELFIE
        GestureDetector(

            onTap: pickImage,

            child: Column(

            children: [

        CircleAvatar(

        radius: 55,

        backgroundColor:
        Colors.grey.shade300,

        backgroundImage:

        selectedImage != null

            ? FileImage(
            selectedImage!)
        as ImageProvider

            : null,

        child:

        selectedImage == null

            ? const Icon(
          Icons.camera_alt,
          size: 40,
        )

            : null,
      ),

      const SizedBox(height: 10),

      const Text(

        "Take Driver Selfie",

        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      ],
    ),
    ),

              const SizedBox(height: 30),

// NRC
              TextField(

                controller:
                nrcController,

                keyboardType:
                TextInputType.number,

                onChanged: formatNRC,

                decoration:
                const InputDecoration(

                  labelText:
                  "NRC Number",

                  hintText:
                  "000000/00/0",

                  border:
                  OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

// LICENSE
              TextField(

                controller:
                licenseController,

                keyboardType:
                TextInputType.number,

                maxLength: 8,

                decoration:
                const InputDecoration(

                  labelText:
                  "Driver License Number",

                  border:
                  OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

// VEHICLE PLATE
              TextField(

                controller:
                plateNumberController,

                textCapitalization:
                TextCapitalization.characters,

                decoration:
                const InputDecoration(

                  labelText:
                  "Vehicle Plate Number",

                  hintText:
                  "BAP3174",

                  suffixText: "ZM",

                  border:
                  OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

// VEHICLE TYPE
              TextField(

                controller:
                vehicleTypeController,

                decoration:
                const InputDecoration(

                  labelText:
                  "Vehicle Make/Model/Year",

                  hintText: "Toyota/Hiace/2018",

                  border:
                  OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

// DATE OF BIRTH
        TextField(

            controller:
            dobController,

            keyboardType:
            TextInputType.number,

            onChanged: formatDOB,

            decoration:
            const InputDecoration(

            labelText:
        "Date of Birth",

        hintText:
        "DD/MM/YYYY",

            border:
            OutlineInputBorder(),
      ),
    ),

    const SizedBox(height: 20),

// ADDRESS
              TextField(

                controller:
                addressController,

                decoration:
                const InputDecoration(

                  labelText:
                  "Address",

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

              ElevatedButton(

                onPressed:
                isLoading
                    ? null
                    : saveDriverProfile,

                child:
                isLoading

                    ? const
                CircularProgressIndicator()

                    : const Text(
                    "Save Driver Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
