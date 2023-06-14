// ignore_for_file: file_names

import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/View/Components/Profile/ThumbnailVideo.dart';
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
      _controller = VideoPlayerController.network(widget.path);
      print("typeaaaaaaaaaaaa ${widget.type}");
      // _controller = VideoPlayerController.network(
      //   "${AppUrl.imageUrl}${widget.path}",
      // );

      _controller.addListener(() {
        setState(() {});
      });
      _controller.setLooping(true);
      _controller.initialize().then((_) => setState(() {}));
      _controller.play();
    }
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black,
      child: widget.type == "image"
          ? InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(0.0),
              minScale: 0.1,
              maxScale: 2.0,
              child: Image(
                image: NetworkImage(widget.path),
                fit: BoxFit.contain,
              ))
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              VideoPlayer(_controller),
                              // _ControlsOverlay(controller: _controller),
                              VideoProgressIndicator(_controller,
                                  allowScrubbing: true),
                            ],
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                });
                              },
                              child: CircleAvatar(
                                radius: 33,
                                backgroundColor: Colors.black38,
                                child: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
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

//GestureDetector 
