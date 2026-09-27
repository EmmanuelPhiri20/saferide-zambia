import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'auth_gate.dart';

class RegisterPage extends StatefulWidget {
const RegisterPage({super.key});

@override
State<RegisterPage> createState() =>
_RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

// AUTH SERVICE
  final AuthService _authService =
  AuthService();

// CONTROLLERS
  final TextEditingController fullNameController =
  TextEditingController();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController phoneController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

// DEFAULT ROLE
  String selectedRole = 'passenger';

// LOADING STATE
  bool isLoading = false;

// =========================
// REGISTER USER FUNCTION
// =========================

  Future<void> registerUser() async {
// START LOADING
    setState(() {
      isLoading = true;
    });

// CALL AUTH SERVICE
    String result =
    await _authService.registerUser(

      fullName:
      fullNameController.text.trim(),

      email:
      emailController.text.trim(),

      phone:
      phoneController.text.trim(),

      password:
      passwordController.text.trim(),

      role: selectedRole,
    );


// SUCCESS
    if (result == "success") {

    // STOP LOADING
    if (mounted) {

    setState(() {
    isLoading = false;
    });
    }

    // FORCE AUTHGATE REBUILD
    Navigator.pushAndRemoveUntil(

    context,

    MaterialPageRoute(
    builder: (_) => const AuthGate(),
    ),

    (route) => false,
    );
    }


// ERROR
    else {
      // STOP LOADING
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(result),
        ),
      );
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(

        appBar: AppBar(
          title: const Text("Register"),
          centerTitle: true,
        ),

        body: Padding(

          padding: const EdgeInsets.all(20),

          child: SingleChildScrollView(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.stretch,

              children: [

                const SizedBox(height: 40),

// APP TITLE
                const Text(
                  "SafeRide Zambia",

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

// FULL NAME FIELD
                TextField(

                  controller:
                  fullNameController,

                  decoration:
                  const InputDecoration(

                    labelText: "Full Name",

                    border:
                    OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

// EMAIL FIELD
                TextField(

                  controller: emailController,

                  keyboardType:
                  TextInputType.emailAddress,

                  decoration:
                  const InputDecoration(

                    labelText: "Email",

                    hintText:
                    "example@gmail.com",

                    border:
                    OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

// PHONE NUMBER FIELD
                TextField(

                  controller:
                  phoneController,

                  keyboardType:
                  TextInputType.phone,

                  decoration:
                  const InputDecoration(

                    labelText: "Phone Number",

                    hintText:
                    "+260xxxxxxxxx",

                    border:
                    OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

// PASSWORD FIELD
                TextField(

                  controller:
                  passwordController,

                  obscureText: true,

                  decoration:
                  const InputDecoration(

                    labelText: "Password",

                    border:
                    OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

// ROLE DROPDOWN
                DropdownButtonFormField<String>(

                  value: selectedRole,

                  decoration:
                  const InputDecoration(

                    labelText: "Select Role",

                    border:
                    OutlineInputBorder(),
                  ),

                  items: const [

                    DropdownMenuItem(
                      value: 'passenger',
                      child: Text('Passenger'),
                    ),

                    DropdownMenuItem(
                      value: 'driver',
                      child: Text('Driver'),
                    ),
                  ],

                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),

                const SizedBox(height: 30),

// REGISTER BUTTON
                ElevatedButton(

                  onPressed:
                  isLoading
                      ? null
                      : registerUser,

                  child: isLoading

                      ? const CircularProgressIndicator()

                      : const Text("Register"),
                ),

                const SizedBox(height: 20),

// LOGIN NAVIGATION
                TextButton(

                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/login',
                    );
                  },

                  child: const Text(
                    "Already have an account? Login",
                  ),
                ),
              ],
            ),
          ),

        ),
      );
    }
  }
