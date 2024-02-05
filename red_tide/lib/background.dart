import 'package:flutter/material.dart';
import 'package:red_tide/screens/login.dart';
import 'package:red_tide/screens/signup.dart';

class BackgroundScreen extends StatelessWidget {
  const BackgroundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.jpg'), fit: BoxFit.cover),
          ),
          child: Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(builder: (context) {
                switch (settings.name) {
                  case '/signup':
                    return const SignupScreen();
                  case '/login':
                    return const LoginScreen();
                  default:
                    return const LoginScreen();
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
