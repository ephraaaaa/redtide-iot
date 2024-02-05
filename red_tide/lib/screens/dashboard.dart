// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:red_tide/navigation.dart';
import 'package:red_tide/widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child("real-time-data/");

  int pH = 0;
  int turbidity = 0;
  @override
  void initState() {
    super.initState();
    databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        setState(
          () {
            pH = data['pH'] ?? 0.0;
            turbidity = data['turbidity'] ?? 0;
          },
        );
      }
    });
    fetchDocuments();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> weekData = [];
  Future<void> fetchDocuments() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('weekdays')
          .orderBy(FieldPath.documentId)
          .get();
      List<Map<String, dynamic>> tempWeekData = [];

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        tempWeekData.add(data);
      }
      setState(() {
        weekData = tempWeekData;
      });
    } catch (e) {
      debugPrint('Error fetching week data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/background.jpg"), fit: BoxFit.cover),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 100, bottom: 150),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              customContainer(70, 425, 35, "REALTIME READINGS"),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          customOutputContainer(
                              turbidity.toDouble(), "Turbidity"),
                          SizedBox(
                            width: 20,
                          ),
                          customOutputContainer(pH.toDouble(), "pH")
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              customContainer(50, 1000, 30, "SEVEN-DAY READINGS"),
              SizedBox(
                height: 10,
              ),
              Column(
                children: <Widget>[
                  customContainer(30, 250, 25, "TURBIDITY"),
                  SizedBox(
                    height: 5,
                  ),
                  customGraph(
                      5, Colors.red, "Turbidity", weekData, 'turbidity'),
                  SizedBox(
                    height: 10,
                  ),
                  customContainer(30, 100, 25, "PH"),
                  SizedBox(
                    height: 5,
                  ),
                  customGraph(14, Colors.green, "pH", weekData, 'pH')
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
