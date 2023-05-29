// ignore_for_file: file_names

import 'package:chatapp/View/Screens/Camera/CameraScreen.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CameraScreen(
      onImageSend: () {},
    );
  }
}
