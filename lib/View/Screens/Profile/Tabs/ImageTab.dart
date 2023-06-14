// ignore_for_file: file_names

import 'package:chatapp/Model/Model/ChatMessagesModel.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/View/Components/Profile/ThumbnailVideo.dart';
import 'package:chatapp/View/Screens/Profile/Screens/PageViewImages.dart';
import 'package:chatapp/ViewModel/ChatPage/ChatMessagesViewModel.dart';
import 'package:flutter/material.dart';

class ImageTab extends StatefulWidget {
  const ImageTab({super.key, this.otherUserName});
  final String? otherUserName;

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
    List<ChatMessagesModel>? data;
    if (widget.otherUserName == null) {
      data = await chatMessagesViewModel.getPhotos();
    } else {
      data = await chatMessagesViewModel
          .getOtherPhotos(widget.otherUserName ?? "");
    }

    setState(() {
      chatMessagesList = data!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
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
