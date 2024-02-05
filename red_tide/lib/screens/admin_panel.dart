// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:red_tide/widget.dart';

import 'package:http/http.dart' as http;

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

List<dynamic> userList = [];
int userCount = 0;
List<bool> checkedStatus = List.filled(userCount, false);

bool isDeleteButtonVisible = false;

class _AdminScreenState extends State<AdminScreen> {
  @override
  void initState() {
    super.initState();
    generateUserList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 1000),
              child: Text(
                "Hello, Admin!",
                style: GoogleFonts.roboto(
                  textStyle:
                      TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      customText("No. of signed users", 20, Colors.black),
                      customText(userCount.toString(), 100, Colors.black)
                    ],
                  ),
                ), //item1
                SizedBox(
                  width: 300,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "LIST OF USERS",
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 300,
                      width: 600,
                      child: Center(
                        child: ListView.builder(
                          itemCount: userList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: customText(
                                    userList[index]["email"], 15, Colors.black),
                                leading: Checkbox(
                                  value: checkedStatus[index],
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        checkedStatus[index] = value!;
                                        isDeleteButtonVisible =
                                            checkedStatus.contains(true);
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ), //item2
                Visibility(
                  visible: isDeleteButtonVisible,
                  child: FloatingActionButton(
                    onPressed: () async {
                      List<Map<String, dynamic>> selectedUsers = [];
                      for (int i = 0; i < userList.length; i++) {
                        if (checkedStatus[i] == true) {
                          selectedUsers.add(userList[i]);
                        }
                      }
                      await deleteSelectedUsers(selectedUsers);
                      List<Map<String, dynamic>> tempData = List.from(userList);
                      List<bool> tempCheckedStatus = List.from(checkedStatus);
                      for (int i = tempData.length - 1; i >= 0; i--) {
                        if (tempCheckedStatus[i] == true) {
                          tempData.removeAt(i);
                          tempCheckedStatus.removeAt(i);
                        }
                      }
                      setState(() {
                        userList.addAll(tempData);
                        checkedStatus.clear();
                        checkedStatus.addAll(tempCheckedStatus);
                        isDeleteButtonVisible = false;
                      });
                    },
                    tooltip: 'Delete',
                    child: Icon(Icons.delete),
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.refresh),
            tooltip: "Refresh",
            onPressed: () {
              setState(() {
                checkedStatus.clear();
                userList.clear();
              });
            }),
      ),
    );
  }

  Future<void> generateUserList() async {
    try {
      // Make an HTTP POST request to your Flask serverf
      final response = await http.get(
        Uri.parse(
            'https://redtidemonitoringsystemserver.click/server/generate-users-list'),
      );

      if (response.statusCode == 200) {
        print('User list fetch successful');
        userList = json.decode(response.body);
        print("Output: $userList");
        setState(() {
          userList = userList;
          userCount = userList.length;
          print(userCount);
        });
      } else {
        print('Failed to fetch. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> deleteSelectedUsers(
      List<Map<String, dynamic>> selectedUsers) async {
    final Uri uri = Uri.parse(
        'https://redtidemonitoringsystemserver.click/server/delete-users');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"users": selectedUsers}),
    );

    if (response.statusCode == 200) {
      print("Users deleted successfully");
    } else {
      print("Error deleting users: ${response.statusCode}");
    }
  }
}
