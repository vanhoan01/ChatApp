// ignore_for_file: file_names

import 'package:chatapp/Model/Model/ChatMessagesModel.dart';
import 'package:chatapp/View/Components/Profile/ReactHistoryView.dart';
import 'package:chatapp/ViewModel/ChatPage/ChatMessagesViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SavedTab extends StatefulWidget {
  const SavedTab({super.key});

  @override
  State<SavedTab> createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> {
  List<ChatMessagesModel> chatMessagesList = [];
  ChatMessagesViewModel chatMessagesViewModel = ChatMessagesViewModel();

  @override
  void initState() {
    super.initState();
    getSaveds();
  }

  void getSaveds() async {
    List<ChatMessagesModel>? data = await chatMessagesViewModel.getSaveds();
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
