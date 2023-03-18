// ignore_for_file: file_names

import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_downloader/image_downloader.dart';
// import 'package:path_provider/path_provider.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? _image;
  String? _url;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  // ignore: unnecessary_null_comparison
                  backgroundImage: _image == null ? null : FileImage(_image!),
                  radius: 80,
                ),
                // GestureDetector(
                //     onTap: pickImage, child: const Icon(Icons.camera_alt))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () {
                      // uploadImage(context);
                    },
                    child: const Text('Upload Image'),
                  ),
                ),
                const SizedBox(width: 10),
                // ElevatedButton(
                //   onPressed: loadImage,
                //   child: const Text('Load Image'),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }

  // void pickImage() async {
  //   var image = await ImagePicker().pickImage(source: ImageSource.camera);

  //   setState(() {
  //     _image = image as File?;
  //   });
  // }

  // void uploadImage(context) async {
  //   try {
  //     // FirebaseStorage storage =
  //     //     FirebaseStorage(storageBucket: 'gs://chatstore-5eaeb.appspot.com');
  //     // final ref = storage.ref().child(_image!.path);
  //     // final storageUploadTask = ref.putFile(_image!);
  //     // final taskSnapshot = await storageUploadTask.whenComplete(() => null);
  //     // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //     //   content: Text('success'),
  //     // ));
  //     // String url = await taskSnapshot.ref.getDownloadURL();
  //     // // ignore: avoid_print
  //     // print('url $url');
  //     // setState(() {
  //     //   _url = url;
  //     // });
  //   } catch (ex) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(ex.toString()),
  //     ));
  //   }
  // }

  // void loadImage() async {
  //   var imageId = await ImageDownloader.downloadImage(_url!);
  //   var path = await ImageDownloader.findPath(imageId!);
  //   File image = File(path!);
  //   setState(() {
  //     _image = image;
  //   });
  // }
}
