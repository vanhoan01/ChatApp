// ignore_for_file: file_names

import 'package:chatapp/Model/Model/ChatModel.dart';
import 'package:chatapp/Model/Model/ConversationModel.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/View/Screens/Conversation/ConversationScreen.dart';
import 'package:chatapp/View/Screens/Group/Add/AddMemberScreen.dart';
import 'package:chatapp/View/Screens/Pages/Homescreen.dart';
import 'package:chatapp/View/Screens/Profile/Tabs/FileTab.dart';
import 'package:chatapp/View/Screens/Profile/Tabs/ImageTab.dart';
import 'package:chatapp/View/Screens/Profile/Tabs/StatisticalTab.dart';
import 'package:chatapp/ViewModel/ChatPage/ChatMessagesViewModel.dart';
import 'package:chatapp/ViewModel/ConversationViewModel.dart';
import 'package:flutter/material.dart';

class GroupProfileScreen extends StatefulWidget {
  const GroupProfileScreen(
      {super.key, required this.id, required this.myUserName});
  final String id;
  final String myUserName;
  @override
  State<GroupProfileScreen> createState() => _GroupProfileScreenState();
}

class _GroupProfileScreenState extends State<GroupProfileScreen>
    with SingleTickerProviderStateMixin {
  ConversationViewModel conversationViewModel = ConversationViewModel();
  ConversationModel? conversationModel;
  TabController? _tabController;
  ChatMessagesViewModel chatMessagesViewModel = ChatMessagesViewModel();

  @override
  void initState() {
    super.initState();
    getGroup();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  void getGroup() async {
    ConversationModel data =
        await conversationViewModel.getConversationViewModel(widget.id);
    setState(() {
      conversationModel = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,
        title: const Text(
          "Nhóm chat",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          maxLines: 1,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (builder) => bottomsheet());
            },
            icon: const Icon(Icons.menu, color: Colors.black),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              backgroundImage: NetworkImage(
                  "${AppUrl.imageUrl}${conversationModel != null ? conversationModel!.avatarImage : ""}"),
              radius: 55,
            ),
            const SizedBox(height: 10),
            Text(
              conversationModel != null ? conversationModel!.displayName : "",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      showAlertDialogCheck(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(width: 1, color: Colors.red),
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      "Rời khỏi nhóm",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => ConversationScreen(
                            chatModel: ChatModel(
                              userName: widget.id,
                              avatarImage: conversationModel!.avatarImage,
                              currentMessage: "",
                              displayName: conversationModel!.displayName,
                              isGroup: true,
                              timestamp: DateTime.now(),
                            ),
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          width: 1, color: Color.fromRGBO(224, 224, 224, 1)),
                    ),
                    child: const Text(
                      "Gửi tin nhắn",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
              ],
            ),
            const SizedBox(height: 15),
            Column(
              children: [
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.black,
                  labelColor: Colors.black,
                  labelPadding: const EdgeInsets.all(2),
                  tabs: const [
                    Tab(text: "Ảnh Video"),
                    Tab(text: "Tệp"),
                    Tab(text: "Thống kê"),
                  ],
                ),
                SizedBox(
                  height: 500,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ImageTab(otherUserName: widget.id),
                      FileTab(otherUserName: widget.id),
                      StatisticalTab(otherUserName: widget.id),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomsheet() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          actionTile(
            Icons.person_add_alt_outlined,
            "Thêm thành viên",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => AddMemberScreen(
                    chatModel: ChatModel(
                      userName: widget.id,
                      avatarImage: conversationModel!.avatarImage,
                      currentMessage: "",
                      displayName: conversationModel!.displayName,
                      isGroup: true,
                      timestamp: DateTime.now(),
                    ),
                  ),
                ),
              );
            },
          ),
          actionTile(Icons.block, "Chặn", () {}),
        ],
      ),
    );
  }

  showAlertDialogCheck(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Bạn muốn rời khỏi nhóm này?"),
      actions: [
        TextButton(
          child: const Text("Hủy", style: TextStyle(color: Colors.black)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text(
            "Rời khỏi nhóm",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () async {
            var response = await conversationViewModel.leaveGroup(widget.id);
            if (response.statusCode == 200) {
              // ignore: use_build_context_synchronously
              await sendNotify("@${widget.myUserName} đã rời khỏi nhóm", true);
              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Homescreen()),
                  (route) => false);
            } else {
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            }
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> sendNotify(String text, bool isGroup) async {
    //database
    String id = await chatMessagesViewModel.addChatMessage(
      widget.myUserName,
      widget.id,
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

  // ignore: non_constant_identifier_names
  Widget actionTile(IconData? icon, String text, Function() fun) {
    return InkWell(
      onTap: fun,
      child: SizedBox(
        height: 47,
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 15),
            Icon(
              icon,
              color: Colors.black,
              size: 24,
            ),
            const SizedBox(width: 15),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
