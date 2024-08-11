import 'package:fashion_organiser/libraryscreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // Handle the selected image
      print('Image path: ${image.path}');
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
                  const Icon(
                    Icons.camera_alt_sharp,
                    color: Color(0XFFFEE9CE),
                    size: 35,
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
