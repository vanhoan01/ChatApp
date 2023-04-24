// ignore_for_file: file_names

import 'package:chatapp/View/NewScreen/CallScreen.dart';
import 'package:chatapp/View/Pages/ChatPage.dart';
import 'package:chatapp/View/Pages/StatusPage.dart';
import 'package:chatapp/View/Profile/ProfilePage.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.teal,
        child: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelPadding: const EdgeInsets.all(2),
          tabs: const [
            // Tab(icon: Icon(Icons.camera_alt)),
            Tab(text: "ĐOẠN CHAT"),
            Tab(text: "TRẠNG THÁI"),
            Tab(text: "CUỘC GỌI"),
            Tab(text: "HỒ SƠ"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ChatPage(),
          const StatusPage(),
          const CallScreen(),
          const ProfilePage(),
        ],
      ),
    );
  }
}
