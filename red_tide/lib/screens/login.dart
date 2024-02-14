// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:red_tide/navigation.dart';
import 'package:red_tide/navigation_admin.dart';
import 'package:red_tide/widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showIncorrectCredentials = false;

  Future<void> signIn(
      BuildContext context, String email, String password) async {
    if (email == 'admin' && password == 'admin') {
      // Admin logged in
      debugPrint("Admin logged in!");
      setState(() {
        showIncorrectCredentials = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationScreenAdmin(),
        ),
      );
    } else {
      // Regular user logged in
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        if (userCredential != null &&
            FirebaseAuth.instance.currentUser != null) {
          // admin logic to add:
          // admin cred: admin - username
          // admin cred: admin - password
          String userUid = FirebaseAuth.instance.currentUser!.uid;
          debugPrint("User logged in!");
          setState(() {
            showIncorrectCredentials = false;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationScreen(),
            ),
          );
        }
      } catch (e) {
        debugPrint("Error signing in $e");
        setState(() {
          showIncorrectCredentials = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Color.fromRGBO(26, 24, 23, 1).withOpacity(.7),
        height: 500,
        width: 700,
        child: Center(
          //start
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Text("LOGIN",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold)),
              customSizedBox(20),
              customFormField(
                  Icons.person, Colors.white, _emailController, false, "Email"),
              customSizedBox(20),
              customFormField(Icons.lock, Colors.white, _passwordController,
                  true, "Password"),
              customSizedBox(10),
              showIncorrectCredentials
                  ? Text(
                      "Incorrect email or password. Please try again.",
                      style: TextStyle(color: Colors.red),
                    )
                  : SizedBox(),
              customSizedBox(20),
              customButton(35, 200, () {
                signIn(
                    context, _emailController.text, _passwordController.text);
              }, "LOGIN"),
              customSizedBox(10),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/signup'),
                child: Text(
                  "Don't have an account? Signup",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 15,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
