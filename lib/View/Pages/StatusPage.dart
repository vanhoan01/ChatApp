// ignore_for_file: file_names

import 'package:chatapp/Model/Model/OthersStatusModel.dart';
import 'package:chatapp/Model/Model/userModel.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/View/CustomUI/StatusPage/HeadOwnStatus.dart';
import 'package:chatapp/View/CustomUI/StatusPage/OthersStatusWidget.dart';
import 'package:chatapp/ViewModel/Profile/UserViewModel.dart';
import 'package:chatapp/ViewModel/StatusPage/OthersStatusListViewModel.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  OthersStatusListViewModel othersStatusListViewModel =
      OthersStatusListViewModel();
  List<OthersStatusModel> _otherStatusList = [];
  late IO.Socket socket;
  UserViewModel userViewModel = UserViewModel();

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void getFriendStatus() async {
  //   List<OthersStatusModel> data =
  //       await othersStatusListViewModel.getFriendStatus();
  //   setState(() {
  //     _otherStatusList = data;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 48,
            child: FloatingActionButton(
              backgroundColor: Colors.blueGrey[100],
              elevation: 8,
              onPressed: () {},
              child: Icon(
                Icons.edit,
                color: Colors.blueGrey[900],
              ),
            ),
          ),
          const SizedBox(height: 13),
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.greenAccent[700],
            elevation: 5,
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeadOwnStatus(),
            label("Đang hoạt động (100)"),
            for (var item in _otherStatusList)
              OthersStatusWidget(
                othersStatusModel: item,
              ),
            const SizedBox(height: 10),
            label("Không hoạt động (150)"),
          ],
        ),
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
              lastSeenAt: subject['lastSeenAt']));
        });
        print("data ${data.isEmpty ? [] : data.elementAt(0).displayName}");
        if (mounted) {
          setState(() {
            _otherStatusList = data;
          });
        } else {
          _otherStatusList = data;
        }
      });
    });
  }

  Widget label(String lablename) {
    return Container(
      height: 33,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        child: Text(
          lablename,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
