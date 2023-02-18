// ignore_for_file: file_names

import 'package:chatapp/View/MenuView/MenuScreen.dart';
import 'package:chatapp/View/NewScreen/CallScreen.dart';
import 'package:chatapp/View/Pages/CameraPage.dart';
import 'package:chatapp/View/Pages/ChatPage.dart';
import 'package:chatapp/View/Pages/StatusPage.dart';
import 'package:chatapp/View/Screens/CreateGroup.dart';
import 'package:chatapp/View/Screens/LoginScreen.dart';
import 'package:chatapp/View/Screens/SearchScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Whatsapp'),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const CreateGroup()));
              }
              if (value == "Settings") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const MenuScreen()));
              }
              // ignore: avoid_print
              print(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'New group',
                  child: Text('Tạo nhóm mới'),
                ),
                const PopupMenuItem(
                  value: 'Starred messages',
                  child: Text('Tin nhắn quan trọng'),
                ),
                const PopupMenuItem(
                  value: 'Settings',
                  child: Text('Cài đặt'),
                ),
                const PopupMenuItem(
                  value: 'dangxuat',
                  child: Text('Đăng xuất'),
                ),
              ];
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelPadding: const EdgeInsets.all(2),
          tabs: const [
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
          const CameraPage(),
          ChatPage(),
          const StatusPage(),
          const CallScreen(),
        ],
      ),
    );
  }

  void logout() async {
    await storage.delete(key: "token");
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
  }
}
