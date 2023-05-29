// ignore_for_file: file_names

import 'package:chatapp/Model/Model/OthersStatusModel.dart';
import 'package:chatapp/Model/Model/userModel.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/View/Screens/Pages/StatusPage/Tabs/FriendRequest.dart';
import 'package:chatapp/View/Screens/Pages/StatusPage/Tabs/FriendTab.dart';
import 'package:chatapp/View/Screens/Pages/StatusPage/Tabs/GroupTab.dart';
import 'package:chatapp/View/Screens/SearchScreen.dart';
import 'package:chatapp/ViewModel/UserViewModel.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage>
    with SingleTickerProviderStateMixin {
  late IO.Socket socket;
  UserViewModel userViewModel = UserViewModel();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    // connect();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liên hệ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchScreen(),
              );
            },
            icon: const Icon(Icons.search, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            labelPadding: const EdgeInsets.all(2),
            automaticIndicatorColorAdjustment: false,
            tabs: const [
              Tab(text: "Bạn bè"),
              Tab(text: "Nhóm"),
              Tab(text: "Lời mời kết bạn"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                FriendTab(),
                GroupTab(),
                FriendRequest(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> connect() async {
    socket = IO.io(AppUrl.baseUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    // ignore: await_only_futures
    await socket.connect();
    UserModel? userModel = await userViewModel.getUserModel();
    socket.emit("signin", userModel.userName);
    print("Đã signin");
    socket.emit("activecontacts", userModel.userName);
    print("Đã activecontacts");
    socket.onConnect((data) {
      // ignore: avoid_print
      print("Connected");

      socket.on("activecontacts", (msg) {
        // ignore: avoid_print
        print("nhận msg: $msg");
        List<OthersStatusModel> data = [];
        msg.forEach((subject) {
          // ... Do something here with items here
          data.add(OthersStatusModel(
              avatarImage: subject['avatarImage'],
              displayName: subject['displayName'],
              isGroup: subject['isGroup'],
              lastSeenAt: subject['lastSeenAt'],
              precense: subject['precense']));
        });
        print("data ${data.isEmpty ? [] : data.elementAt(0).displayName}");
        if (mounted) {
          setState(() {
            // _otherStatusList = data;
          });
        } else {
          // _otherStatusList = data;
        }
      });
    });
  }
}
