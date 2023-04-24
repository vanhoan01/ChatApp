import 'package:chatapp/Model/Model/ChatMessagesModel.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/View/Image/ImageProfileScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageViewImages extends StatefulWidget {
  const PageViewImages(
      {super.key, required this.chatMessagesList, required this.position});
  final List<ChatMessagesModel> chatMessagesList;
  final int position;

  @override
  State<PageViewImages> createState() => _PageViewImagesState();
}

class _PageViewImagesState extends State<PageViewImages> {
  late PageController _controller;
  int imageindex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      imageindex = widget.position;
    });
  }

  @override
  Widget build(BuildContext context) {
    _controller = PageController(initialPage: widget.position);
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.chatMessagesList.length,
            itemBuilder: (BuildContext context, int index) {
              return ImageProfileScreen(
                path: AppUrl.imageUrl + widget.chatMessagesList[index].text,
                type: widget.chatMessagesList[index].type,
              );
            },
            onPageChanged: (value) {
              setState(() {
                imageindex = value;
              });
            },
          ),
          Positioned(
            top: 30,
            left: 5,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 5,
            child: IconButton(
              icon: const Icon(
                Icons.file_download_outlined,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () => print(imageindex),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 5,
            child: IconButton(
              icon: const Icon(
                Icons.share,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () => print(imageindex),
            ),
          ),
        ],
      ),
    );
  }
}
