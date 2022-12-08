import 'package:chatapp/CustomUI/ButtonCard.dart';
import 'package:chatapp/CustomUI/ContactCard.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Screens/CreateGroup.dart';
import 'package:chatapp/Screens/SearchScreen.dart';
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
              'Chọn liên hệ',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '265 liên hệ',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchScreen(),
              );
            },
            icon: Icon(
              Icons.search,
              size: 26,
            ),
          ),
          PopupMenuButton<String>(
            offset: const Offset(-20, 45),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            onSelected: (value) {
              print(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Mời một người bạn'),
                  value: 'Invite a friend',
                ),
                PopupMenuItem(
                  child: Text('Các liên hệ'),
                  value: 'Contacts',
                ),
                PopupMenuItem(
                  child: Text('Làm mới'),
                  value: 'Refresh',
                ),
                PopupMenuItem(
                  child: Text('Trợ giúp'),
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
              child: ButtonCard(icon: Icons.group, name: 'Nhóm mới'),
            );
          } else if (index == 1) {
            return InkWell(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: SearchScreen(),
                  );
                },
                child: ButtonCard(icon: Icons.person, name: 'Liên hệ mới'));
          }
          return ContactCard(contact: contacts[index - 2]);
        },
      ),
    );
  }
}
