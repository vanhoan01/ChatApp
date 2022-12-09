import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Screens/IndividualPage.dart';
import 'package:chatapp/Services/metwork_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchItem extends StatelessWidget {
  final ChatModel chatModel;
  const SearchItem({Key? key, required this.chatModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String path = chatModel.avatarImage;
    NetworkHandler networkHandler = NetworkHandler();
    String url = networkHandler.getURL();
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => IndividualPage(chatModel: chatModel)));
      },
      child: Column(
        children: [
          ListTile(
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
                      chatModel.isGroup
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
              chatModel.displayName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              chatModel.currentMessage,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1,
            ),
          )
        ],
      ),
    );
  }
}
