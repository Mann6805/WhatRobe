import 'dart:io';

import 'package:fashion_organiser/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class Camerascreen extends StatefulWidget {
  const Camerascreen({super.key});

  @override
  State<Camerascreen> createState() => _CamerascreenState();
}

class _CamerascreenState extends State<Camerascreen> {
  CameraController? _controller;
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  bool taken = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    CameraDescription description = cameras[0];
    _controller = CameraController(description, ResolutionPreset.medium);
    await _controller!.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _takePicture() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
         _imageFile = await _controller!.takePicture();
        setState(() {});
        print('Picture taken: ${_imageFile?.path}');
      } catch (e) {
        print('Error occurred while taking picture: $e');
      }
    } else {
      print("Camera is not initialized");
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _done() {
    if (_imageFile != null){
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(
          builder: (context) {
            return Homescreen(image : _imageFile!.path);
          }
        ),
        (route){
          return false;
        }
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _controller != null && _controller!.value.isInitialized && _imageFile == null
              ? CameraPreview(_controller!)
              : Image.file(File(_imageFile!.path)),
          Positioned(
            height: _height/9,
            bottom: 0,
            child: Container(
              width: _width,
              decoration: const BoxDecoration(
                color: Color(0XFFA4B5C4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library, size: 50, color: Color(0XFFFEE9CE)),
                    onPressed: _pickImage,
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo_camera, size: 50, color: Color(0XFFFEE9CE)),
                    onPressed: _takePicture,
                  ),
                  IconButton(
                    icon: const Icon(Icons.check_circle, size: 50, color: Color(0XFFFEE9CE)),
                    onPressed: _done,
                  ), // Space on the right to balance the layout
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
