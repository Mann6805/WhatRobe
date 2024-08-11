import 'dart:io';

import 'package:fashion_organiser/camerascreen.dart';
import 'package:fashion_organiser/libraryscreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class Homescreen extends StatefulWidget {
  
  String? image;
  Homescreen({super.key, required this.image});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _promptcontroller = new TextEditingController();

  Future<String?> fetchGeminiResponse(String userInput, String imageUrlOrBase64) async {
    const String apiKey = "AIzaSyBdITjGKPyfRX1yIMRBsnYVq8tbCWku97s";

    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
    String prompt = "Describe the clothes of image: $imageUrlOrBase64";
    final response = await model.generateContent([Content.text(prompt)]);
    print(response.text);
    return response.text;
  }

  Future<void> _openCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
      String fileName = 'images/${DateTime.now()}.png';
      Reference storageRef = _storage.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(_image!);

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      print("Image uploaded successfully. Download URL: $downloadUrl");
    } catch (e) {
      print("Failed to upload image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0XFFFEE9CE), size: 45),
        backgroundColor: const Color(0xff071739),
      ),
      drawer: Drawer(
        backgroundColor: Colors.green,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xff071739),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _height/15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LibraryScreen())),
                  child: const Icon(
                    Icons.image,
                    color: Color(0XFFFEE9CE),
                    size: 80,
                  ),
                ),
                InkWell(
                  onTap: () => _openCamera(),
                  child: const Icon(
                    Icons.add_box_rounded,
                    color: Color(0XFFFEE9CE),
                    size: 80,
                  ),
                )
              ],
            ),
            SizedBox(
              height: _height/20,
            ),
            Container(
              height: 60,
              width: 250,
              decoration: BoxDecoration(
                  color: const Color(0xffA4B5C4),
                  borderRadius: BorderRadius.circular(15)),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "I want to go for a Movie...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0XFFFEE9CE),
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _height/50,
            ),
            Container(
              height: 60,
              width: 250,
              decoration: BoxDecoration(
                  color: const Color(0xffA4B5C4),
                  borderRadius: BorderRadius.circular(15)),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "I want to go for a Birthday...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0XFFFEE9CE),
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _height/50,
            ),
            Container(
              height: 60,
              width: 250,
              decoration: BoxDecoration(
                  color: const Color(0xffA4B5C4),
                  borderRadius: BorderRadius.circular(15)),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "I want to go for a Marraige Function...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0XFFFEE9CE),
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _height/50,
            ),
            Container(
              height: 60,
              width: 250,
              decoration: BoxDecoration(
                  color: const Color(0xffA4B5C4),
                  borderRadius: BorderRadius.circular(15)),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "I want to go for a Date...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0XFFFEE9CE),
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _height/5,
            ),
            Container(
              height: _height/15,
              width: _width/1.2,
              decoration: BoxDecoration(
                color: const Color(0xffA4B5C4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: _width/30,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context){
                            return const Camerascreen();
                          }
                        )
                      );
                    },
                    child: const Icon(
                      Icons.camera_alt_sharp,
                      color: Color(0XFFFEE9CE),
                      size: 35,
                    ),
                  ),
                  SizedBox(
                    width: _width/30,
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Color(0XFFFEE9CE),),
                      cursorColor: const Color(0XFFFEE9CE),
                    ),
                  ),
                  SizedBox(
                    width: _width/30,
                  ),
                  const Icon(
                    Icons.send,
                    color: Color(0XFFFEE9CE),
                    size: 35,
                  ),
                  SizedBox(
                    width: _width/30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
