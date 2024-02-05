// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:red_tide/screens/login.dart';
import 'package:red_tide/widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reEnterPassword = TextEditingController();
  bool showIncorrectCredentials = false;

  Future<void> signUp(BuildContext context, String email, String password,
      String reEnterPassword) async {
    if (password != reEnterPassword) {
      setState(() {
        showIncorrectCredentials = true;
      });
      print("Passwords do not match");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          print("Signed up successfully!");
          setState(() {
            showIncorrectCredentials = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        }
      } catch (e) {
        print("Trouble signing up. Please try again");
        showIncorrectCredentials = true;
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _reEnterPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 500,
        width: 500,
        color: Colors.white.withOpacity(.7),
        child: Center(
          child: Column(
            children: <Widget>[
              customSizedBox(80),
              Text(
                "SIGNUP",
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 50),
              ),
              customSizedBox(20),
              customFormField(
                  Icons.person, Colors.black, _emailController, false, "Email"),
              customSizedBox(20),
              customFormField(Icons.lock, Colors.black, _passwordController,
                  true, "Password"),
              customSizedBox(20),
              customFormField(Icons.lock, Colors.black, _reEnterPassword, true,
                  "Re-enter Password"),
              customSizedBox(20),
              showIncorrectCredentials
                  ? Text(
                      "Passwords do not match. Please try again.",
                      style: TextStyle(color: Colors.red),
                    )
                  : SizedBox(),
              customSizedBox(30),
              customButton(35, 200, () {
                signUp(context, _emailController.text, _passwordController.text,
                    _reEnterPassword.text);
              }, "SIGNUP"),
              customSizedBox(10),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/login'),
                child: Text(
                  "Have an account? Login here",
                  style: TextStyle(
                      decoration: TextDecoration.underline, fontSize: 15),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
