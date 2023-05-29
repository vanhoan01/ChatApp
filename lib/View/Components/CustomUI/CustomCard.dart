// ignore_for_file: file_names

import 'package:chatapp/Model/Model/ChatModel.dart';
import 'package:chatapp/View/Screens/Conversation/ConversationScreen.dart';
import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/ViewModel/ChatPage/text_time_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCard extends StatelessWidget {
  final ChatModel chatModel;
  const CustomCard({Key? key, required this.chatModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String path = chatModel.avatarImage;
    NetworkHandler networkHandler = NetworkHandler();
    String url = networkHandler.getURL();
    return ListTile(
      tileColor: Colors.white,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(chatModel: chatModel),
          ),
        );
      },
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: path.isNotEmpty
            ? NetworkImage(
                "$url/uploads/$path",
              )
            : null,
        // ignore: sort_child_properties_last
        child: path.isEmpty
            ? SvgPicture.asset(
                chatModel.isGroup ? 'assets/groups.svg' : 'assets/person.svg',
                color: Colors.white,
                height: 37,
                width: 37,
              )
            : Container(),
        backgroundColor: Colors.blueGrey,
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                chatModel.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              width: 7,
            ),
            Text(
              TextTimeVM(time: chatModel.timestamp).getTextChatTime(),
              style: const TextStyle(
                fontSize: 13,
              ),
            )
          ],
        ),
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              chatModel.currentMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(
            width: 7,
          ),
          chatModel.currentMessage == ""
              ? Container()
              : const ClipOval(
                  child: Material(
                    color: Color.fromRGBO(189, 189, 189, 1), // Button color
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: Icon(
                        Icons.done,
                        size: 11,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
        ],
      ),
      // trailing: Text(TextTimeVM(time: chatModel.timestamp).getTextChatTime()),
    );
  }
}
