// ignore_for_file: file_names

import 'package:chatapp/Model/Model/ChatMessagesModel.dart';
import 'package:chatapp/View/Components/Profile/FileView.dart';
import 'package:chatapp/ViewModel/ChatPage/ChatMessagesViewModel.dart';
import 'package:flutter/material.dart';

class FileTab extends StatefulWidget {
  const FileTab({super.key});

  @override
  State<FileTab> createState() => _FileTabState();
}

class _FileTabState extends State<FileTab> {
  List<ChatMessagesModel> chatMessagesList = [];
  ChatMessagesViewModel chatMessagesViewModel = ChatMessagesViewModel();

  @override
  void initState() {
    super.initState();
    getPhotos();
  }

  void getPhotos() async {
    List<ChatMessagesModel>? data = await chatMessagesViewModel.getFiles();
    setState(() {
      chatMessagesList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      color: Colors.grey.shade200,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: chatMessagesList.length,
        itemBuilder: (BuildContext context, int index) {
          return FileView(
            name: chatMessagesList[index].text,
            size: chatMessagesList[index].size ?? 0,
          );
        },
      ),
    );
  }
}
