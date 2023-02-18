// ignore_for_file: file_names

import 'package:chatapp/View/CustomUI/ButtonCard.dart';
import 'package:chatapp/View/CustomUI/ContactCard.dart';
import 'package:chatapp/Model/ChatterModel.dart';
import 'package:chatapp/Model/ListChatterModel.dart';
import 'package:chatapp/View/Screens/CreateGroup.dart';
import 'package:chatapp/View/Screens/SearchScreen.dart';
import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:flutter/material.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({Key? key}) : super(key: key);

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  NetworkHandler networkHandler = NetworkHandler();
  List<ChatterModel> contacts = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var responseChatters = await networkHandler.get("/user/get/friends");
    var listChatterModel = ListChatterModel.fromJson(responseChatters);
    var listChatters = listChatterModel.data;

    List<ChatterModel> listCM = [];
    ChatterModel chatterModel;

    for (var i = 0; i < listChatters!.length; i = i + 1) {
      chatterModel = ChatterModel(
          userName: listChatters.elementAt(i).userName,
          displayName: listChatters.elementAt(i).displayName,
          avatarImage: listChatters.elementAt(i).avatarImage.toString(),
          precense: listChatters.elementAt(i).precense,
          select: false);
      listCM.add(chatterModel);
    }
    // ignore: avoid_print
    print(listCM);
    setState(() {
      contacts = listCM;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
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
            icon: const Icon(
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
              // ignore: avoid_print
              print(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'Invite a friend',
                  child: Text('Mời một người bạn'),
                ),
                const PopupMenuItem(
                  value: 'Contacts',
                  child: Text('Các liên hệ'),
                ),
                const PopupMenuItem(
                  value: 'Refresh',
                  child: Text('Làm mới'),
                ),
                const PopupMenuItem(
                  value: 'Help',
                  child: Text('Trợ giúp'),
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
