import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery/Admin/admin_login.dart';
import 'package:food_delivery/Pages/signUp_page.dart';
import 'package:food_delivery/Pages/splash_screen.dart';
import 'package:food_delivery/Widgets/secret.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey=publishableKey;
  Platform.isAndroid
    ? await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBsjeVJD6r-1dMA4MM6UCYKmnyKOVwcMC4",
        appId: "1:903715064777:android:46af4d3e401432cf2d3618",
        messagingSenderId: "903715064777",
        projectId: "food-delivery-cb1fb",
        storageBucket: "food-delivery-cb1fb.appspot.com"
      ),
    )
    : await Firebase.initializeApp();
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Choice',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home:SplashScreen(),
    );
  }
}