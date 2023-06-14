// ignore_for_file: file_names

import 'dart:io';

import 'package:chatapp/Resources/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ThumbnailVideo extends StatefulWidget {
  const ThumbnailVideo({super.key, required this.videoPath});
  final String videoPath;

  @override
  State<ThumbnailVideo> createState() => _ThumbnailVideoState();
}

class _ThumbnailVideoState extends State<ThumbnailVideo> {
  String? _thumbnailUrl;
  @override
  void initState() {
    super.initState();

    generateThumbnail();
  }

  void generateThumbnail() async {
    // print("videoPath: ${widget.videoPath}");
    _thumbnailUrl = await VideoThumbnail.thumbnailFile(
        video: widget.videoPath,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.WEBP);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        InkWell(
          child: _thumbnailUrl != null
              ? Image.file(
                  File(_thumbnailUrl!),
                  fit: BoxFit.cover,
                )
              : Image.asset('assets/images/thumbnailvideo.png'),
        ),
        Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 2, color: Colors.white)),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
              )),
        ),
      ]),
    );
  }
}
