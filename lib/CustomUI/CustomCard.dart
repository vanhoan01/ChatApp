import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Pages/IndividualPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCard extends StatelessWidget {
  final ChatModel chatModel;
  final ChatModel sourchat;
  const CustomCard({Key? key, required this.chatModel, required this.sourchat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => IndividualPage(
                      chatModel: chatModel,
                      sourchat: sourchat,
                    )));
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: SvgPicture.asset(
                chatModel.isGroup ? 'assets/groups.svg' : 'assets/person.svg',
                color: Colors.white,
                height: 37,
                width: 37,
              ),
              backgroundColor: Colors.blueGrey,
            ),
            title: Text(
              chatModel.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(Icons.done_all),
                SizedBox(
                  width: 3,
                ),
                Text(
                  chatModel.currentMessage,
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing: Text(chatModel.time),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1,
            ),
          )
        ],
      ),
    );
  }
}
