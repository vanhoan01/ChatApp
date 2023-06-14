// ignore_for_file: file_names

import 'package:chatapp/Model/List/ListChatterModel.dart';
import 'package:chatapp/Model/Model/ChatModel.dart';
import 'package:chatapp/Model/Model/ChatterModel.dart';
import 'package:chatapp/View/Components/CustomUI/AvtarCard.dart';
import 'package:chatapp/View/Components/CustomUI/ContactCard.dart';
import 'package:chatapp/View/Screens/Conversation/ConversationScreen.dart';
import 'package:chatapp/View/Screens/SearchScreen.dart';
import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/ViewModel/ChatPage/ChatMessagesViewModel.dart';
import 'package:chatapp/ViewModel/ConversationViewModel.dart';
import 'package:flutter/material.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({Key? key, required this.chatModel}) : super(key: key);
  final ChatModel chatModel;

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  NetworkHandler networkHandler = NetworkHandler();
  final ConversationViewModel _conversationViewModel = ConversationViewModel();
  List<ChatterModel> contacts = [];
  List<ChatterModel> groups = [];
  ChatMessagesViewModel chatMessagesViewModel = ChatMessagesViewModel();

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
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Thêm thành viên',
          style: TextStyle(
              fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchScreen(),
              );
            },
            icon: const Icon(Icons.search, size: 26, color: Colors.black),
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
        onPressed: () async {
          List<Map<String, String>> members = groups
              .map((e) =>
                  {"userName": e.userName, "memberShipStatus": "Thành viên"})
              .toList();
          var response = await _conversationViewModel.addMembers(
              widget.chatModel.userName, members);

          if (response.statusCode == 200) {
            // ignore: use_build_context_synchronously
            for (var e in groups) {
              await sendNotify(
                  "@${e.userName} đã tham gia nhóm", true, e.userName);
            }
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) =>
                    ConversationScreen(chatModel: widget.chatModel),
              ),
            );
          }
        },
        backgroundColor: const Color(0xFF128C7E),
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Future<void> sendNotify(String text, bool isGroup, String userName) async {
    //database
    String id = await chatMessagesViewModel.addChatMessage(
      userName,
      widget.chatModel.userName,
      isGroup,
      "Notification",
      text,
      DateTime.now(),
      "",
    );
    // ignore: avoid_print
    print(id);

    //local
  }
}
