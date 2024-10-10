import 'package:flutter/material.dart';
import 'package:mycityguide/pages/sigin_page.dart';
import 'package:mycityguide/text_file_model/button.dart';
import 'package:mycityguide/text_file_model/text_file.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    // Get screen size
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.008;
    final spacing = size.height * 0.03;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Column(
              children: [
                SizedBox(height: spacing * 1.5),

                // Forgot password in title
                const Text(
                  "Forgot password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: spacing),

                // Enter your email account to reset  your password (text)
                const Text(
                  "Enter your email account to reset  your password",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: spacing),

                // Email textfield
                const MyTextField(
                  hintText: "Enter Email",
                  obscureText: false,
                  obsureText: false,
                ),
                SizedBox(height: spacing),

                // Sign in button
                 Button(onTap: (){
                  LoginPage();
                },
                 text: "Reset Password"),
                SizedBox(height: spacing),
              ],
            ),
          ),
        ),
      ),
    );
  }
}