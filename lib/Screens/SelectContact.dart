import 'package:chatapp/CustomUI/ButtonCard.dart';
import 'package:chatapp/CustomUI/ContactCard.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Screens/CreateGroup.dart';
import 'package:flutter/material.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({Key? key}) : super(key: key);

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  @override
  Widget build(BuildContext context) {
    List<ChatModel> contacts = [
      ChatModel.ChatModelContact('Dev Stack', 'full stack'),
      ChatModel.ChatModelContact('Balram', 'Flutter developer'),
      ChatModel.ChatModelContact('Saket', 'Flutter developer'),
      ChatModel.ChatModelContact('Dev', 'Flutter developer'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Contact',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '265contacts',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              size: 26,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              print(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Invite a friend'),
                  value: 'Invite a friend',
                ),
                PopupMenuItem(
                  child: Text('Contacts'),
                  value: 'Contacts',
                ),
                PopupMenuItem(
                  child: Text('Refresh'),
                  value: 'Refresh',
                ),
                PopupMenuItem(
                  child: Text('Help'),
                  value: 'Help',
                ),
              ];
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => CreateGroup()));
                // print('hihi');
              },
              child: ButtonCard(icon: Icons.group, name: 'New group'),
            );
          } else if (index == 1) {
            return ButtonCard(icon: Icons.person, name: 'New contact');
          }
          return ContactCard(contact: contacts[index - 2]);
        },
      ),
    );
  }
}
