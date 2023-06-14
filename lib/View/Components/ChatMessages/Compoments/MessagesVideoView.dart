// ignore_for_file: file_names

import 'dart:io';

import 'package:chatapp/Resources/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MessagesVideoView extends StatefulWidget {
  const MessagesVideoView({
    Key? key,
    required this.path,
    required this.reply,
    required this.color,
  }) : super(key: key);
  final String path;
  final bool reply;
  final bool color;

  @override
  State<MessagesVideoView> createState() => _MessagesVideoViewState();
}

class _MessagesVideoViewState extends State<MessagesVideoView> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.path.length > 20
        ? VideoPlayerController.file(File(widget.path))
        : VideoPlayerController.network(
            "${AppUrl.imageUrl}${widget.path}",
          );
    print("video ${AppUrl.imageUrl}${widget.path}");
    // _controller = VideoPlayerController.network(
    //   "${AppUrl.imageUrl}${widget.path}",
    // );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.pause();
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
      // height: 160,
      // width: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.color ? Colors.blue : Colors.grey.shade200,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
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
                      VideoProgressIndicator(_controller, allowScrubbing: true),
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
          widget.reply == false
              ? const SizedBox(height: 0)
              : const SizedBox(height: 15),
        ],
      ),
    );
  }
}
