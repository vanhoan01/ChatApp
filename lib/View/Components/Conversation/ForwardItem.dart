// ignore_for_file: file_names

import 'package:chatapp/Model/Model/ChatModel.dart';
import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/ViewModel/ChatPage/ChatMessagesViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForwardItem extends StatefulWidget {
  const ForwardItem(
      {Key? key,
      required this.chatModel,
      required this.userName,
      required this.chatMMId})
      : super(key: key);
  final ChatModel chatModel;
  final String userName;
  final String chatMMId;

  @override
  State<ForwardItem> createState() => _ForwardItemState();
}

class _ForwardItemState extends State<ForwardItem> {
  final ChatMessagesViewModel _chatMessagesViewModel = ChatMessagesViewModel();

  Future<void> sendMessage() async {
    //database
    String id = await _chatMessagesViewModel.addChatMessage(
      widget.userName,
      widget.chatModel.userName,
      widget.chatModel.isGroup,
      "Forward",
      "",
      DateTime.now(),
      widget.chatMMId,
    );
    // ignore: avoid_print
    print("id: $id");
  }

  @override
  Widget build(BuildContext context) {
    String path = widget.chatModel.avatarImage;
    NetworkHandler networkHandler = NetworkHandler();
    String url = networkHandler.getURL();
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: path.isNotEmpty
            ? NetworkImage(
                "$url/uploads/$path",
              )
            : null,
        // ignore: sort_child_properties_last
        child: path.isEmpty
            ? SvgPicture.asset(
                widget.chatModel.isGroup
                    ? 'assets/groups.svg'
                    : 'assets/person.svg',
                color: Colors.white,
                height: 37,
                width: 37,
              )
            : Container(),
        backgroundColor: Colors.blueGrey,
      ),
      title: Text(
        widget.chatModel.displayName,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        widget.chatModel.currentMessage,
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
      trailing: TextButton(
        onPressed: () {
          sendMessage();
        },
        style: TextButton.styleFrom(
            minimumSize: const Size(20, 10),
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            foregroundColor: Colors.black54,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.black38, width: 0.5)),
            textStyle:
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        child: const Text("GỬI"),
      ),
    );
  }
}
