import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'GetStart.dart';
import 'User_Controller/Auth_Controller.dart';
import 'BottomBar_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    final auth = Provider.of<Authentication>(context, listen: false);
    bool isLoggedIn = await auth.checkLoginState();
    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BottomBar()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GetStart()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: 500,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/WhatsApp Image 2024-06-10 at 10.35.07_bf13c43f.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 120),
                child: Row(
                  children: [
                    Image(
                      image: AssetImage('assets/images/vai.png'),
                      width: 180,
                      height: 180,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
