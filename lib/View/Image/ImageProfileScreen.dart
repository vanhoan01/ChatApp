// ignore_for_file: file_names

import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/View/Profile/Compoments/ThumbnailVideo.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ImageProfileScreen extends StatefulWidget {
  const ImageProfileScreen({super.key, required this.path, required this.type});
  final String path;
  final String type;

  @override
  State<ImageProfileScreen> createState() => _ImageProfileScreenState();
}

class _ImageProfileScreenState extends State<ImageProfileScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.type == "video") {
      _controller = VideoPlayerController.network(widget.path)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black,
      child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(0.0),
        minScale: 0.1,
        maxScale: 2.0,
        child: widget.type == "image"
            ? Image(
                image: NetworkImage(widget.path),
                fit: BoxFit.contain,
              )
            : _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
      ),
    );
  }
}

//GestureDetector 
