import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LibraryScreen extends StatefulWidget {

  String pathname;
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
  LibraryScreen({super.key, required this.pathname});
}

class _LibraryScreenState extends State<LibraryScreen>{

  late Future<List<String>> _imageUrlsFuture;

  void initState() {
    super.initState();  
    _imageUrlsFuture = getImageUrls();
  }

  void _confirmDelete(BuildContext context, String urlpath) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Do you really want to delete this image?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
              _deleteimages(context, urlpath);
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}

void _deleteimages(BuildContext context, String urlpath) async {
  try {
    await FirebaseStorage.instance.refFromURL(urlpath).delete();
    setState(() {
      _imageUrlsFuture = getImageUrls();
    });
  } catch (e) {
    print('Error deleting image: $e');
  }
}

  Future<List<String>> getImageUrls() async {
    List<String> imageUrls = [];
    final ListResult result = await FirebaseStorage.instance.ref(widget.pathname).listAll();
    for (var ref in result.items) {
      String url = await ref.getDownloadURL();
      imageUrls.add(url);
    }
    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _height/10,
        backgroundColor: const Color(0XFF071739),
        leading: IconButton(
          icon: const Icon( 
            Icons.arrow_circle_left_sharp,
            color: Color(0XFFFEE9CE),
            size: 50,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<String>>(
        future: _imageUrlsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No images found.', style: TextStyle(color: const Color(0XFF071739), fontSize: 30),),);
          } else {
            List<String> imagePaths = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: imagePaths.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => _confirmDelete(context,imagePaths[index]),
                    child: Container(
                      color: Colors.grey[300],
                      child: Image.network(
                        imagePaths[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}