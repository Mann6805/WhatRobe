import 'package:fashion_organiser/homescreen.dart';
import 'package:fashion_organiser/loginscreen.dart';
import 'package:fashion_organiser/provider/userprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    // Check for user login status
    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (user==null){
          openLogin();
        }
        else {
          openDashboard();
        }
      }  
    );
  
  }

  void openDashboard(){
    Provider.of<UserProvider>(context, listen: false).getUserData();
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
          builder: (context) {
            return Homescreen(image: null,);
          }
        )
    );
  }

  void openLogin(){
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          }
        )
    );
  } 

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0XFF071739),
      body: Center(
        child: Image(image: AssetImage("assets/logo.png"))
      ),
    );
  }
  
}