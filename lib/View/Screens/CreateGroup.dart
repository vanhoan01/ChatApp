// ignore_for_file: file_names

import 'package:chatapp/Model/List/ListChatterModel.dart';
import 'package:chatapp/Model/Model/ChatterModel.dart';
import 'package:chatapp/View/Components/CustomUI/AvtarCard.dart';
import 'package:chatapp/View/Components/CustomUI/ContactCard.dart';
import 'package:chatapp/View/Screens/NewGroup.dart';
import 'package:chatapp/View/Screens/SearchScreen.dart';
import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  NetworkHandler networkHandler = NetworkHandler();
  List<ChatterModel> contacts = [];
  List<ChatterModel> groups = [];

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
              'Nhóm mới',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Thêm người tham gia',
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
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: contacts.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  height: groups.isNotEmpty ? 90 : 10,
                );
              }
              return InkWell(
                onTap: () {
                  if (contacts[index - 1].select == false) {
                    setState(() {
                      contacts[index - 1].select = true;
                      groups.add(contacts[index - 1]);
                    });
                  } else {
                    setState(() {
                      contacts[index - 1].select = false;
                      groups.remove(contacts[index - 1]);
                    });
                  }
                },
                child: ContactCard(contact: contacts[index - 1]),
              );
            },
          ),
          groups.isNotEmpty
              ? Column(
                  children: [
                    Container(
                      height: 75,
                      color: Colors.white,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          if (contacts[index].select == true) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  contacts[index].select = false;
                                  groups.remove(contacts[index]);
                                });
                              },
                              child: AvtarCard(contact: contacts[index]),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                  ],
                )
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => NewGroup(groups: groups),
            ),
          );
        },
        backgroundColor: const Color(0xFF128C7E),
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
