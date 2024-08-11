import 'package:fashion_organiser/firebase_options.dart';
import 'package:fashion_organiser/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );  
  Gemini.init(apiKey: "AIzaSyBdITjGKPyfRX1yIMRBsnYVq8tbCWku97s");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FashionOrg',
      home: Scaffold(
        body: Homescreen(image: null),
      ),
    );
  }
}
