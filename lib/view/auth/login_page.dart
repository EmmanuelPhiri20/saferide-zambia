import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../view/auth/auth_gate.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {

  final AuthService _authService =
  AuthService();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  bool isLoading = false;

  // LOGIN USER
  void loginUser() async {

    setState(() {
      isLoading = true;
    });

    String result =
    await _authService.loginUser(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    // SUCCESS
    if (result == "success") {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Login Successful",
          ),
        ),
      );

      Navigator.pushAndRemoveUntil(

        context,

        MaterialPageRoute(
          builder: (_) => const AuthGate(),
        ),

            (route) => false,

      );

    } else {

      // ERROR
      ScaffoldMessenger.of(context).showSnackBar(
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
        title: const Text("Login"),
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

              const Text(
                "SafeRide Zambia",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              // EMAIL
              TextField(
                controller: emailController,
                keyboardType:
                TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // PASSWORD
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              // LOGIN BUTTON
              ElevatedButton(

                onPressed:
                isLoading ? null : loginUser,

                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Login"),
              ),

              const SizedBox(height: 20),

              // REGISTER NAVIGATION
              TextButton(

                onPressed: () {

                  Navigator.pushNamed(
                    context,
                    '/register',
                  );
                },

                child: const Text(
                  "Don't have an account? Register",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}