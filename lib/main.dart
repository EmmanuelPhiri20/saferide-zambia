import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';

import 'view/auth/auth_gate.dart';
import 'view/auth/login_page.dart';
import 'view/auth/register_page.dart';
import 'view/home/home_page_passenger.dart';
import 'view/home/home_page_driver.dart';
import 'view/home/home_page_admin.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      theme: AppTheme.lightTheme,

      debugShowCheckedModeBanner: false,

      title: 'SafeRide Zambia',

      home: const AuthGate(),

      routes: {

        '/login': (context) =>
        const LoginPage(),

        '/register': (context) =>
        const RegisterPage(),

        '/passengerHome': (context) =>
        const PassengerHomePage(),

        '/driverHome': (context) =>
        const DriverHomePage(),

        '/adminHome': (context) =>
        const AdminHomePage(),
      },
    );
  }
}