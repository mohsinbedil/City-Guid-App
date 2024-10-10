import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mycityguide/pages/sigin_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      // ignore: prefer_const_constructors
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/screen.gif",fit: BoxFit.fitWidth,width: double.infinity,),
      ),
      // backgroundColor: Color.fromRGBO(13, 110, 253, 1.000),
    );
  }
}