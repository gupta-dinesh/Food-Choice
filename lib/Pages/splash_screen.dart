import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_delivery/Pages/Onboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  splashScreenTimer(){
    Timer(const Duration(seconds: 2),()async{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Onboard(),));
    },);
  }

  @override
  void initState() {
    super.initState();
    splashScreenTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.lightBlueAccent,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset("assets/images/Food Delivery Logo.png",fit:BoxFit.cover,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
