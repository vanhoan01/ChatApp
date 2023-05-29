// ignore_for_file: file_names

import 'package:chatapp/Model/Model/ChatMessagesModel.dart';
import 'package:chatapp/View/Components/Profile/ReactHistoryView.dart';
import 'package:chatapp/ViewModel/ChatPage/ChatMessagesViewModel.dart';
import 'package:flutter/material.dart';

class LikeTab extends StatefulWidget {
  const LikeTab({super.key});

  @override
  State<LikeTab> createState() => _LikeTabState();
}

class _LikeTabState extends State<LikeTab> {
  List<ChatMessagesModel> chatMessagesList = [];
  ChatMessagesViewModel chatMessagesViewModel = ChatMessagesViewModel();

  @override
  void initState() {
    super.initState();
    getProfileReacts();
  }

  void getProfileReacts() async {
    List<ChatMessagesModel>? data =
        await chatMessagesViewModel.getProfileReacts();
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
          return ReactHistoryView(
            cotent: chatMessagesList[index].text,
            type: chatMessagesList[index].type,
            author: chatMessagesList[index].author,
          );
        },
      ),
    );
  }
}
