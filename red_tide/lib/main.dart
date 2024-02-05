// ignore_for_file: prefer_const_constructors, unused_import

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:red_tide/navigation.dart';
import 'package:red_tide/navigation_admin.dart';
import 'package:red_tide/screens/area.dart';
import 'package:red_tide/screens/dashboard.dart';
import 'package:red_tide/screens/login.dart';
import 'package:red_tide/screens/signup.dart';
import 'package:red_tide/screens/splash.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCAzkH5lIyVoOYAtIpfRdhsK611AuPV2lk",
          appId: "1:896700458309:web:adc0ec4464a79f5c144a2c",
          messagingSenderId: "896700458309",
          projectId: "red-tide-monitoring",
          databaseURL:
              "https://red-tide-monitoring-default-rtdb.asia-southeast1.firebasedatabase.app"),
    );
  }
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body:SplashScreen()),
    ),
  );
}
//SplashScreen()