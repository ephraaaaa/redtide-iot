// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:red_tide/background.dart';
import 'package:red_tide/navigation.dart';
import 'package:red_tide/screens/area.dart';
import 'package:red_tide/screens/dashboard.dart';
import 'package:red_tide/screens/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 4),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BackgroundScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset("assets/animations/ocean_animation.json",
          height: 500, width: 500),
    );
  }
}
