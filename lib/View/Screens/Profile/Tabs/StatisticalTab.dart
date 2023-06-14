// ignore_for_file: file_names

import 'package:chatapp/Model/Model/ChatMessagesModel.dart';
import 'package:chatapp/ViewModel/ChatPage/ChatMessagesViewModel.dart';
import 'package:flutter/material.dart';

class StatisticalTab extends StatefulWidget {
  const StatisticalTab({super.key, this.otherUserName});
  final String? otherUserName;

  @override
  State<StatisticalTab> createState() => _StatisticalTabState();
}

class _StatisticalTabState extends State<StatisticalTab> {
  List<ChatMessagesModel> chatMessagesList = [];
  ChatMessagesViewModel chatMessagesViewModel = ChatMessagesViewModel();

  @override
  void initState() {
    super.initState();
    // getPhotos();
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
    return GridView(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
      ),
      children: [
        itemStatistical("Tổng số tin nhắn", 500),
        itemStatistical("Số tin nhắn bạn đã gửi", 500),
        itemStatistical("Số ảnh video", 500),
        itemStatistical("Số file", 500),
      ],
    );
  }

  Widget itemStatistical(String title, int number) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0),
        border: Border.all(width: 0.5, color: Colors.grey.shade400),
      ),
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
      height: 30,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(title),
          ),
          Expanded(
            child: Center(
              child: Text(
                "$number",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
