import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_organiser/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupController {

  static Future<void> createAccount({required String email, required String password, required String name, required BuildContext context}) async{
    try{
      print("hello1");
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: password
      );  
      print("hello2");

      var userId = FirebaseAuth.instance.currentUser!.uid;
      var db = FirebaseFirestore.instance;

      Map<String, dynamic> data = {
        "name": name,
        "email" : email,
        "id" : userId.toString()
      };

      try{
         await db.collection("users").doc(userId.toString()).set(data);
      }
      // ignore: empty_catches
      catch(e) { }
      

      Navigator.pushAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context, 
      MaterialPageRoute(
          builder: (context) {
            return const SplashScreen();
          }
        ),
      (route) {
        return false;
      }
    );
    }
    catch (e) {
      print(e);
      SnackBar messagesnackbar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(e.toString())
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        (messagesnackbar)
      );
    }
  }

}