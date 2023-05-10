// ignore_for_file: file_names

import 'package:chatapp/Model/Model/userModel.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/View/CallkitIncoming/AppRoute.dart';
import 'package:chatapp/View/CallkitIncoming/NavigationService.dart';
import 'package:chatapp/View/ChatPage/Screens/VideoCallScreen.dart';
import 'package:chatapp/View/NewScreen/CallScreen.dart';
import 'package:chatapp/View/Pages/ChatPage.dart';
import 'package:chatapp/View/Pages/StatusPage.dart';
import 'package:chatapp/View/Profile/ProfilePage.dart';
import 'package:chatapp/ViewModel/Profile/UserViewModel.dart';
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
    // connectSocket();
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

  Future<void> connectSocket() async {
    UserViewModel userViewModel = UserViewModel();
    UserModel userModel = await userViewModel.getUserModel();
    socket = IO.io(AppUrl.baseUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    // ignore: await_only_futures
    socket.connect();
    socket.emit("signin", userModel.userName);
    socket.onConnect((data) {
      // ignore: avoid_print
      print("Connected");
      socket.on("calling", (msg) {
        // ignore: avoid_print
        print("Nhận cuộc gọi: ${msg[0]}");
        // NavigationService.instance
        //   .pushNamedIfNotCurrent(AppRoute.callingPage, args: currentCall);
        Navigator.push(
          NavigationService.instance.navigationKey.currentContext ?? context,
          MaterialPageRoute(
            builder: (context) => VideoCallScreen(
              caller: msg[1],
              creceiver: msg[0],
              callStatus: false,
            ),
          ),
        );
      });
    });
  }
}
