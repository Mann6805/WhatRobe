import 'package:fashion_organiser/provider/userprovider.dart';
import 'package:fashion_organiser/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Activate App Check (using Debug mode for development)
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug, // Use PlayIntegrity for production
  );  
  Gemini.init(apiKey: "AIzaSyBdITjGKPyfRX1yIMRBsnYVq8tbCWku97s");
  runApp(ChangeNotifierProvider(
      create : (context) => UserProvider(),
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FashionOrg',
      home: Scaffold(
        body: SplashScreen(),
      ),
    );
  }
}
