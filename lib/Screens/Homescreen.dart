import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/NewScreen/CallScreen.dart';
import 'package:chatapp/Pages/CameraPage.dart';
import 'package:chatapp/Pages/ChatPage.dart';
import 'package:chatapp/Pages/StatusPage.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  Homescreen({Key? key, required this.chatmodels, required this.sourchat})
      : super(key: key);
  final List<ChatModel> chatmodels;
  final ChatModel sourchat;

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Whatsapp'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          PopupMenuButton<String>(
            onSelected: (value) {
              print(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('New group'),
                  value: 'New group',
                ),
                PopupMenuItem(
                  child: Text('New broadcast'),
                  value: 'New broadcast',
                ),
                PopupMenuItem(
                  child: Text('Whatsapp Web'),
                  value: 'Whatsapp Web',
                ),
                PopupMenuItem(
                  child: Text('Starred messages'),
                  value: 'Starred messages',
                ),
                PopupMenuItem(
                  child: Text('Settings'),
                  value: 'Settings',
                ),
              ];
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(icon: Icon(Icons.camera_alt)),
            Tab(text: "CHATS"),
            Tab(text: "STATUS"),
            Tab(text: "CALLS"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CameraPage(),
          ChatPage(
            chatmodels: widget.chatmodels,
            sourchat: widget.sourchat,
          ),
          StatusPage(),
          CallScreen(),
        ],
      ),
    );
  }
}
