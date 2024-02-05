// ignore_for_file: unused_field, prefer_const_constructors, prefer_final_fields, unused_import, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:red_tide/screens/area.dart';
import 'package:red_tide/screens/dashboard.dart';
import 'package:red_tide/screens/login.dart';
import 'package:red_tide/screens/logs.dart';
import 'package:red_tide/widget.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final List<Widget> _screens = [
    DashboardScreen(),
    LogScreen(),
    MapScreen(),
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        ),
        drawer: Drawer(
          child: Container(
            color: Colors.black,
            child: Center(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                 
                  SizedBox(
                    height: 100,
                  ),
                  navListTiles(
                    Icons.dashboard,
                    'Dashboard',
                    () {
                      _selectScreen(0);
                    },
                    _currentIndex == 0,
                  ),
                  navListTiles(Icons.data_thresholding, "Logs", () {
                    _selectScreen(1);
                  }, _currentIndex == 1),
                  navListTiles(Icons.map, "Location", () {
                    _selectScreen(2);
                  }, _currentIndex == 2),
                  SizedBox(
                    height: 100,
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(left: 50)),
                        Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 35,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Logout',
                          style: GoogleFonts.poppins(
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      signOut(context);
                      debugPrint("Successfully logged out");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        body: _screens[_currentIndex],
      ),
    );
  }

  void _selectScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      navigateToLoginScreen(context);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  void navigateToLoginScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }
}
