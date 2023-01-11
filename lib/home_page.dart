import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File? photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.library_add),
            tooltip: 'Choose Photo',
            onPressed: () async {
              PermissionStatus storageStatus = await Permission.storage.request();
              if(storageStatus == PermissionStatus.granted){

              }
              if(storageStatus == PermissionStatus.denied){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Photo Display needs Storage access to use this feature.")));
                return;
              }
              if(storageStatus == PermissionStatus.permanentlyDenied){
                openAppSettings();
                return;
              }
              XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);
              setState(() {
                photo = File(img!.path);
              }
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            tooltip: 'Capture Photo',
            onPressed: () async {
              PermissionStatus cameraStatus = await Permission.camera.request();
              if(cameraStatus == PermissionStatus.granted){

              }
              if(cameraStatus == PermissionStatus.denied){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Photo Display needs Camera access to use this feature.")));
                return;
              }
              if(cameraStatus == PermissionStatus.permanentlyDenied){
                openAppSettings();
                return;
              }
              XFile? img = await ImagePicker().pickImage(source: ImageSource.camera);
              setState(() {
                photo = File(img!.path);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Clear Photo',
            onPressed: (){
              setState(() {
                photo = null;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: InkWell(
            child: photo == null? Material(
              elevation: 15,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: const Center(child: Text("No Photo Selected!")),
              ),
            ):
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(photo!),
            ),
          ),
        ),
      ),
    );
  }
}