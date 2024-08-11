// ignore_for_file: must_be_immutable

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_organiser/camerascreen.dart';
import 'package:fashion_organiser/libraryscreen.dart';
import 'package:fashion_organiser/provider/userprovider.dart';
import 'package:fashion_organiser/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  String? image;
  Homescreen({super.key, required this.image});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  File? _imagePath;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _promptcontroller = TextEditingController();
  var msgform = GlobalKey<FormState>();
  String? responsetext;
  bool isgetting = false;
  late Future<List<String>> _imageUrlsFuture;

  final List<String> _prompts = [
    "I want to go for Party!!",
    "I want to go for Birthday",
    "I want to go for Marraige",
    "I want to go for Date",
    "I want to go for College Fest",
    "I want to go for Shopping",
    "I want to go for Movie",
  ];

  @override
  void initState() {
    super.initState();
    _imageUrlsFuture = getImageUrls(FirebaseAuth.instance.currentUser!.uid);
    print(FirebaseAuth.instance.currentUser!.uid);
  }

  Widget _buildInitialPromptList(String userId) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xff071739)),
      height: 400,
      width: 300,
      child: ListView.builder(
        itemCount: _prompts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () {
                fetchGeminiResponse(
                    _prompts[index] + " Suggest me a cloth", null, userId);
                setState(() {});
              },
              child: Container(
                height: 60,
                width: 250,
                decoration: BoxDecoration(
                  color: const Color(0xffA4B5C4),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    _prompts[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color(0XFFFEE9CE),
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatUI(List<Map<String, dynamic>> messages, double width) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xff071739)),
      height: 400,
      width: 300,
      child: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  width: width / 1.1,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message['userInput'],
                        style: const TextStyle(
                          color: Color(0XFFFEE9CE),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: width / 1.1,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message['response'],
                        style: const TextStyle(
                          color: Color(0XFFFEE9CE),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<List<String>> getImageUrls(String userid) async {
    List<String> imageUrls = [];
    final ListResult result =
        await FirebaseStorage.instance.ref(userid).listAll();
    for (var ref in result.items) {
      String url = await ref.getDownloadURL();
      imageUrls.add(url);
    }
    return imageUrls;
  }

  Future<void> fetchGeminiResponse(
      String userInput, String? path, String userId) async {
    final Gemini gemini = Gemini.instance;
    List<Uint8List> images = [];
    List<String> imageUrls = await _imageUrlsFuture;

    for (String imageUrl in imageUrls) {
      print(imageUrl);
      final ByteData imageData =
          await NetworkAssetBundle(Uri.parse(imageUrl)).load("");
      images.add(imageData.buffer.asUint8List());
    }

    if (path != null) {
      File file = File(path);
      images.add(file.readAsBytesSync());
    }

    try {
      print(images);
      final response = await gemini.textAndImage(
        text: userInput,
        images: images,
      );
      await _storeConversation(
          userInput, response?.content?.parts?.last.text, userId);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _storeConversation(
      String userInput, String? responseText, String userId) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      await _firestore
          .collection('conversations')
          .doc(userId)
          .collection('messages')
          .add({
        'userInput': userInput,
        'response': responseText,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error storing conversation: $e');
    }
  }

  Future<void> _deleteAllConversations(String userId) async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final collectionRef = _firestore
          .collection('conversations')
          .doc(userId)
          .collection('messages');
      final querySnapshot = await collectionRef.get();
      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting conversations: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> _getMessagesForUser(String userId) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return _firestore
        .collection('conversations')
        .doc(userId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> _openCamera(String name) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = File(pickedFile.path);
      });
      _uploadImage(name);
    }
  }

  Future<void> _uploadImage(String name) async {
    if (_imagePath == null) return;

    try {
      String fileName = '${name}/${DateTime.now()}.png';
      Reference storageRef = _storage.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(_imagePath!);

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      SnackBar messagesnackbar = const SnackBar(
          backgroundColor: Color(0XFF071739),
          content: Text(
            "Image added succesfully",
            style: TextStyle(color: Color(0XFFFEE9CE)),
          ));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar((messagesnackbar));
      print("Image uploaded successfully. Download URL: $downloadUrl");
    } catch (e) {
      print("Failed to upload image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0XFFFEE9CE), size: 45),
        backgroundColor: const Color(0xff071739),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xff071739),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userProvider.userName,
                    style: const TextStyle(
                      color: Color(0XFFFEE9CE),
                      fontSize: 24,
                    ),
                  ),
                  const Text(
                    "Welcome to our app",
                    style: const TextStyle(
                      color: Color(0XFFFEE9CE),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    // ignore: use_build_context_synchronously
                    context, MaterialPageRoute(builder: (context) {
                  return const SplashScreen();
                }), (route) {
                  return false;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Delete Conversation'),
              onTap: () => _deleteAllConversations(userProvider.userId),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xff071739),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _height / 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          LibraryScreen(pathname: userProvider.userId))),
                  child: const Icon(
                    Icons.image,
                    color: Color(0XFFFEE9CE),
                    size: 80,
                  ),
                ),
                InkWell(
                  onTap: () => _openCamera(userProvider.userId),
                  child: const Icon(
                    Icons.add_box_rounded,
                    color: Color(0XFFFEE9CE),
                    size: 80,
                  ),
                )
              ],
            ),
            SizedBox(
              height: _height / 20,
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Color(
                0xff071739,
              )),
              height: _height / 2.1,
              width: _width / 1.1,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _getMessagesForUser(userProvider.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildInitialPromptList(userProvider.userId);
                  } else {
                    return _buildChatUI(snapshot.data!, _width);
                  }
                },
              ),
            ),
            SizedBox(
              height: _height / 20,
            ),
            Container(
              height: _height / 15,
              width: _width / 1.2,
              decoration: BoxDecoration(
                color: const Color(0XFFA4B5C4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                key: msgform,
                child: Row(
                  children: [
                    SizedBox(
                      width: _width / 30,
                    ),
                    InkWell(
                      onLongPress: () {
                        widget.image = null;
                        setState(() {});
                      },
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const Camerascreen();
                        }));
                        setState(() {});
                      },
                      child: widget.image != null
                          ? Image.file(
                              File(widget.image!),
                              width: 40,
                              height: 40,
                            )
                          : const Icon(
                              Icons.camera_alt_sharp,
                              color: Color(0XFFFEE9CE),
                              size: 35,
                            ),
                    ),
                    SizedBox(
                      width: _width / 30,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _promptcontroller,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Color(0XFFFEE9CE),
                        ),
                        cursorColor: const Color(0XFFFEE9CE),
                      ),
                    ),
                    SizedBox(
                      width: _width / 30,
                    ),
                    InkWell(
                      onTap: () async {
                        if (msgform.currentState!.validate() &&
                            _promptcontroller.text.isNotEmpty) {
                          setState(() {
                            isgetting = true;
                          });
                          print(widget.image);
                          await fetchGeminiResponse(_promptcontroller.text,
                              widget.image, userProvider.userId);
                          setState(() {
                            isgetting = false;
                            print(responsetext);
                          });
                        } else {
                          SnackBar messagesnackbar = const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                "Enter Prompt",
                                style: TextStyle(color: Color(0XFFFEE9CE)),
                              ));
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context)
                              .showSnackBar((messagesnackbar));
                        }
                      },
                      child: isgetting
                          ? const CircularProgressIndicator(
                              color: Color(0XFFFEE9CE),
                            )
                          : const Icon(
                              Icons.send,
                              color: Color(0XFFFEE9CE),
                              size: 35,
                            ),
                    ),
                    SizedBox(
                      width: _width / 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
