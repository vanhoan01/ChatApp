// ignore_for_file: file_names

import 'package:chatapp/Model/Model/userModel.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/View/Screens/Pages/CallPage.dart';
import 'package:chatapp/View/Screens/Pages/ChatPage.dart';
import 'package:chatapp/View/Screens/Pages/StatusPage/StatusPage.dart';
import 'package:chatapp/View/Screens/Pages/ProfilePage.dart';
import 'package:chatapp/ViewModel/UserViewModel.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  late IO.Socket socket;

  @override
  void initState() {
    connectSocket();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        child: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey.shade600,
          labelPadding: const EdgeInsets.all(2),
          tabs: [
            TabCustom(Icons.message, "Đoạn chat"),
            TabCustom(Icons.people_alt, "Liên hệ"),
            TabCustom(Icons.call, "Cuộc gọi"),
            TabCustom(Icons.person, "Hồ sơ"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ChatPage(),
          const StatusPage(),
          const CallPage(),
          const ProfilePage(),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Tab TabCustom(IconData icon, String text) {
    return Tab(
      icon: Icon(
        icon,
        size: 23,
      ),
      iconMargin: const EdgeInsets.all(3),
      height: 50,
      child: Text(
        text,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }

  Future<void> connectSocket() async {
    UserViewModel userViewModel = UserViewModel();
    UserModel userModel = await userViewModel.getUserModel();
    socket = IO.io(AppUrl.baseUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.emit("signin", userModel.userName);
  }
}
