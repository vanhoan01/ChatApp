// ignore_for_file: file_names

import 'package:chatapp/Model/Model/CallModel.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/View/Screens/Call/VideoCallScreen.dart';
import 'package:chatapp/ViewModel/ChatPage/ChatMessagesViewModel.dart';
import 'package:chatapp/ViewModel/ChatPage/text_time_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CallPage extends StatefulWidget {
  const CallPage({Key? key}) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  ChatMessagesViewModel chatMessagesViewModel = ChatMessagesViewModel();
  List<CallModel> callModelList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getCalls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cuộc gọi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam_rounded, color: Colors.black),
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: callModelList.length,
              itemBuilder: (BuildContext context, int index) {
                return callCard(callModelList[index]);
              }),
    );
  }

  Future<void> getCalls() async {
    List<CallModel> data = await chatMessagesViewModel.getCalls();
    // NavigationService.instance.navigationKey.currentContext ?? context,
    setState(() {
      callModelList = data;
      loading = false;
    });
  }

  Widget callCard(CallModel callModel) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        onTap: () {
          // Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => VideoCallScreen(
          //                 caller: sourceChat!.userName,
          //                 creceiver: callModel.,
          //                 callStatus: true,
          //               ),
          //             ),
          //           );
        },
        visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
        leading: CircleAvatar(
          radius: 22,
          backgroundImage: callModel.avatarImage != ""
              ? NetworkImage(
                  "${AppUrl.baseUrl}/uploads/${callModel.avatarImage}",
                )
              : null,
          child: callModel.avatarImage == ""
              ? SvgPicture.asset(
                  callModel.isGroup ? 'assets/groups.svg' : 'assets/person.svg',
                  color: Colors.white,
                  height: 28,
                  width: 28,
                )
              : Container(),
        ),
        title: Text(
          callModel.displayName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              callModel.text == "Incoming call"
                  ? Icons.call_made
                  : Icons.call_missed,
              color: Colors.grey,
              size: 20,
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              TextTimeVM(time: callModel.timestamp).getTextTime(),
              style: const TextStyle(
                fontSize: 12.5,
              ),
            ),
          ],
        ),
        trailing: Icon(
          callModel.type == "Video call" ? Icons.videocam_rounded : Icons.call,
          size: 28,
          color: Colors.blue,
        ),
      ),
    );
  }
}
