// ignore_for_file: file_names

import 'package:chatapp/Model/Model/ChatModel.dart';
import 'package:chatapp/Model/Model/ChatterModel.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/Resources/friend.dart';
import 'package:chatapp/View/Screens/Conversation/ConversationScreen.dart';
import 'package:chatapp/View/Screens/Profile/Tabs/FileTab.dart';
import 'package:chatapp/View/Screens/Profile/Tabs/ImageTab.dart';
import 'package:chatapp/View/Screens/Profile/Tabs/StatisticalTab.dart';
import 'package:chatapp/ViewModel/ChatPage/ChatMessagesViewModel.dart';
import 'package:chatapp/ViewModel/ChatterViewModel.dart';
import 'package:chatapp/ViewModel/UserViewModel.dart';
import 'package:flutter/material.dart';

class OtherProfileScreen extends StatefulWidget {
  const OtherProfileScreen(
      {super.key, required this.userName, required this.myUserName});
  final String userName;
  final String myUserName;
  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen>
    with SingleTickerProviderStateMixin {
  ChatterViewModel chatterViewModel = ChatterViewModel();
  ChatterModel? chatterModel;
  TabController? _tabController;
  late String relationship = Friend.banBe;
  UserViewModel userViewModel = UserViewModel();
  final ChatMessagesViewModel _chatMessagesViewModel = ChatMessagesViewModel();

  @override
  void initState() {
    super.initState();
    getChatter();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  void getChatter() async {
    ChatterModel data = await chatterViewModel.getChatterModel(widget.userName);
    setState(() {
      chatterModel = data;
    });
    String relation = await userViewModel.getRelationship(data.userName);
    setState(() {
      relationship = relation.toString();
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
        title: Text(
          chatterModel != null ? "@${chatterModel!.userName}" : "",
          style: const TextStyle(
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
                  "${AppUrl.imageUrl}${chatterModel != null ? chatterModel!.avatarImage : ""}"),
              radius: 55,
            ),
            const SizedBox(height: 10),
            Text(
              chatterModel != null ? chatterModel!.displayName : "",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            chatterModel != null
                ? chatterModel!.biography != null
                    ? Text(
                        chatterModel != null
                            ? chatterModel!.biography ?? ""
                            : "",
                        style: const TextStyle(fontSize: 16),
                      )
                    : const SizedBox()
                : const SizedBox(),
            chatterModel != null
                ? chatterModel!.link != null
                    ? OptionItem(Icons.link,
                        chatterModel != null ? chatterModel!.link ?? "" : "")
                    : const SizedBox()
                : const SizedBox(),
            const SizedBox(height: 15),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      if (relationship == Friend.nguoiLa) {
                        setRelationship(Friend.daGui, Friend.duocNhan);
                        await sendNotify(
                            "@${widget.myUserName} đã gửi lời mời kết bạn",
                            false);
                        setState(() {
                          relationship = Friend.daGui;
                        });
                      } else {
                        if (relationship == Friend.duocNhan) {
                          setRelationship(Friend.banBe, Friend.banBe);
                          await sendNotify(
                              "@${widget.myUserName} đã chấp nhận lời mời kết bạn",
                              false);
                          setState(() {
                            relationship = Friend.banBe;
                          });
                        } else {
                          if (relationship == Friend.daGui) {
                            setRelationship(Friend.nguoiLa, Friend.nguoiLa);
                            await sendNotify(
                                "@${widget.myUserName} đã hủy lời mời kết bạn",
                                false);
                            setState(() {
                              relationship = Friend.nguoiLa;
                            });
                          } else if (relationship == Friend.banBe) {
                            setRelationship(Friend.nguoiLa, Friend.nguoiLa);
                            await sendNotify(
                                "@${widget.myUserName} đã hủy kết bạn", false);
                            setState(() {
                              relationship = Friend.nguoiLa;
                            });
                          }
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      // side: const BorderSide(width: 1, color: Colors.blue),
                      backgroundColor: relationship == Friend.nguoiLa
                          ? Colors.red
                          : Colors.blue,
                    ),
                    child: Text(
                      relationship == Friend.nguoiLa
                          ? "Kết bạn"
                          : relationship == Friend.daGui
                              ? "Đã gửi lời mời"
                              : relationship == Friend.duocNhan
                                  ? "Chấp nhận lời mời"
                                  : "Bạn bè",
                      style: const TextStyle(
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
                              userName: widget.userName,
                              avatarImage: chatterModel!.avatarImage ?? "",
                              currentMessage: "",
                              displayName: chatterModel!.displayName,
                              isGroup: false,
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
                      ImageTab(otherUserName: widget.userName),
                      FileTab(otherUserName: widget.userName),
                      StatisticalTab(otherUserName: widget.userName),
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

  Future<void> setRelationship(String userRela, String chatterRela) async {
    var responseCheck = await userViewModel.checkrelationship(widget.userName);
    print(responseCheck);

    if (responseCheck == false) {
      var response = await userViewModel.addRelationship(
          widget.myUserName, widget.userName, userRela);
      // ignore: avoid_print
      print(response);
      var response1 = await userViewModel.addRelationship(
          widget.userName, widget.myUserName, chatterRela);
      // ignore: avoid_print
      print(response1);
    } else {
      var response = await userViewModel.updateRelationship(
          widget.myUserName, widget.userName, userRela);
      // ignore: avoid_print
      print(response);
      var response1 = await userViewModel.updateRelationship(
          widget.userName, widget.myUserName, chatterRela);
      // ignore: avoid_print
      print(response1);
    }
  }

  Future<void> sendNotify(String text, bool isGroup) async {
    //database
    String id = await _chatMessagesViewModel.addChatMessage(
      widget.myUserName,
      widget.userName,
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

  Widget bottomsheet() {
    return Container(
      height: 156,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: TextButton(
              onPressed: () {},
              child: avatarOption("Chặn"),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () {},
              child: avatarOption("Chia sẻ trang cá nhân"),
            ),
          ),
          Container(
            height: 7,
            color: Colors.grey.shade200,
          ),
          Expanded(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Đóng',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget avatarOption(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget OptionItem(IconData iconData, String title) {
    return ListTile(
      leading: Icon(
        iconData,
        color: Colors.grey,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      horizontalTitleGap: 0,
      // dense: true,
      // contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: -10),
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
    );
  }
}
