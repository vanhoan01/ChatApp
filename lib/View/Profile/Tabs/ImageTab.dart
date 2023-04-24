// ignore_for_file: file_names

import 'package:chatapp/Model/Model/ChatMessagesModel.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/View/Profile/Compoments/ThumbnailVideo.dart';
import 'package:chatapp/View/Profile/Screens/PageViewImages.dart';
import 'package:chatapp/ViewModel/ChatPage/ChatMessagesViewModel.dart';
import 'package:flutter/material.dart';

class ImageTab extends StatefulWidget {
  const ImageTab({super.key});

  @override
  State<ImageTab> createState() => _ImageTabState();
}

class _ImageTabState extends State<ImageTab> {
  List<ChatMessagesModel> chatMessagesList = [];
  ChatMessagesViewModel chatMessagesViewModel = ChatMessagesViewModel();

  @override
  void initState() {
    super.initState();
    getPhotos();
  }

  void getPhotos() async {
    List<ChatMessagesModel>? data = await chatMessagesViewModel.getPhotos();
    setState(() {
      chatMessagesList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        crossAxisCount: 3,
      ),
      itemCount: chatMessagesList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PageViewImages(
                  chatMessagesList: chatMessagesList,
                  position: index,
                ),
              ),
            );
          },
          child: Container(
            child: chatMessagesList[index].type == "image"
                ? Image(
                    image: NetworkImage(
                        AppUrl.imageUrl + chatMessagesList[index].text),
                    fit: BoxFit.cover,
                  )
                : ThumbnailVideo(
                    videoPath: AppUrl.imageUrl + chatMessagesList[index].text),
          ),
        );
      },
    );
  }
}
