// ignore_for_file: file_names

import 'package:chatapp/NewScreen/CallScreen.dart';
import 'package:chatapp/Pages/CameraPage.dart';
import 'package:chatapp/Pages/ChatPage.dart';
import 'package:chatapp/Pages/StatusPage.dart';
import 'package:chatapp/Screens/CreateGroup.dart';
import 'package:chatapp/Screens/LoginScreen.dart';
import 'package:chatapp/Screens/SearchScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Homescreen extends StatefulWidget {
  Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final storage = FlutterSecureStorage();

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
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchScreen(),
              );
            },
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton<String>(
            offset: const Offset(-20, 45),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            onSelected: (value) {
              if (value == "dangxuat") {
                logout();
              }
              if (value == "New group") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => CreateGroup()));
              }
              print(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Tạo nhóm mới'),
                  value: 'New group',
                ),
                PopupMenuItem(
                  child: Text('Tin nhắn quan trọng'),
                  value: 'Starred messages',
                ),
                PopupMenuItem(
                  child: Text('Cài đặt'),
                  value: 'Settings',
                ),
                PopupMenuItem(
                  child: Text('Đăng xuất'),
                  value: 'dangxuat',
                ),
              ];
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelPadding: EdgeInsets.all(2),
          tabs: [
            Tab(icon: Icon(Icons.camera_alt)),
            Tab(text: "ĐOẠN CHAT"),
            Tab(text: "TRẠNG THÁI"),
            Tab(text: "CUỘC GỌI"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CameraPage(),
          ChatPage(),
          StatusPage(),
          CallScreen(),
        ],
      ),
    );
  }

  void logout() async {
    await storage.delete(key: "token");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
  }
}
