// ignore_for_file: prefer_const_constructors, avoid_print, unused_import, prefer_interpolation_to_compose_strings

import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:red_tide/screens/methods.dart';
import 'package:red_tide/widget.dart';
import 'package:intl/intl.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  //run python script

  List<Map<String, dynamic>> selectedDateLogs = [];
  Future<void> fetchDataForDate(DateTime selectedDate) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    String path = 'logs/$formattedDate';
    DataSnapshot dataSnapshot =
        (await databaseReference.child(path).once()).snapshot;
    if (dataSnapshot.value != null) {
      Map<String, dynamic> dataMap = dataSnapshot.value as Map<String, dynamic>;

      setState(() {
        selectedDateLogs = List<Map<String, dynamic>>.from(dataMap.values);
      });
    } else {
      print("There is no data in $formattedDate");
    }
    setState(() {
      selectedDateLogs = selectedDateLogs.reversed.toList();
      print("Selected data: $selectedDateLogs");
    });
  }

  DateTime? selectedDate;
  final databaseReference = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> logData = [];
  Future<void> fetchData() async {
    databaseReference.child('logs').onValue.listen((event) {
      if (event.snapshot.value != null) {
        (event.snapshot.value as Map<dynamic, dynamic>)
            .forEach((dateKey, dateValue) {
          if (dateValue != null) {
            (dateValue as Map<dynamic, dynamic>)
                .forEach((timestampKey, timestampValue) {
              if (timestampValue != null) {
                setState(() {
                  logData.add({
                    'date': dateKey,
                    'timestamp': timestampKey,
                    'pH': timestampValue['pH'],
                    'turbidity': timestampValue['turbidity'],
                  });
                });
              }
            });
          }
        });
        setState(() {
          logData = logData.reversed.toList();
        });
      } else {
        print('No data found.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background.jpg"), fit: BoxFit.cover),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "LOGS",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    color: Colors.black,
                  ),
                  height: 300,
                  width: 800,
                  child: Card(
                    child: ListView.builder(
                      itemCount: logData.length,
                      itemBuilder: (context, index) {
                        var logEntry = logData[index];
      
                        return ListTile(
                          title: customText(
                              "Date: " +
                                  DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(logEntry['timestamp']) * 1000)
                                      .toString(),
                              20,
                              Colors.black),
                          subtitle: customText(
                              "Turbidity: " +
                                  logEntry['turbidity'].toString() +
                                  ", pH: " +
                                  logEntry['pH'].toString(),
                              15,
                              Colors.black),
                        );
                      },
                    ),
                  ),
                ),
                customSizedBox(20),
                customButton(40, 300, () {
                  generateReport();
                }, "EXPORT ALL DATA"),
                customSizedBox(30),
                Container(
                  height: 8,
                  width: 1000,
                  color: Colors.black,
                ),
                customSizedBox(60),
                Text(
                  "DATE SELECTION",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                customButton(40, 300, () async {
                  final DateTime? dateTime = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2999),
                  );
                  if (dateTime != null) {
                    setState(
                      () {
                        selectedDate = dateTime;
                        fetchDataForDate(selectedDate!);
                      },
                    );
                  }
                }, "SELECT A SPECIFIC DATE")
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50),
                ),
                Container(
                  height: 500,
                  width: 400,
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: selectedDateLogs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var selectedLogData = selectedDateLogs[index];
                      print(selectedLogData);
                      return ListTile(
                        title: customText(
                            DateFormat('yyyy-MM-dd')
                                .format(selectedDate!)
                                .toString(),
                            20,
                            Colors.black),
                        subtitle: customText(
                            "Turbidity: " +
                                selectedLogData['turbidity'].toString() +
                                ", pH: " +
                                selectedLogData['pH'].toString(),
                            15,
                            Colors.black),
                      );
                    },
                  ),
                ),
                customSizedBox(20),
                customButton(40, 300, () {}, "EXPORT THIS DATA")
              ],
            )
          ],
        ),
      ),
    );
  }
}
