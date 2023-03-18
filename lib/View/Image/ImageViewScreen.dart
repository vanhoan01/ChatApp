// ignore_for_file: file_names

import 'package:chatapp/Resources/app_urls.dart';
import 'package:flutter/material.dart';

class ImageViewScreen extends StatelessWidget {
  const ImageViewScreen({super.key, required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(0.0),
        minScale: 0.1,
        maxScale: 2.0,
        child: Image.network('${AppUrl.baseUrl}/uploads/$path'),
      ),
    );
  }
}

//GestureDetector 
