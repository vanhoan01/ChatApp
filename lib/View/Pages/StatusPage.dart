// ignore_for_file: file_names

import 'package:chatapp/Model/Model/OthersStatusModel.dart';
import 'package:chatapp/View/CustomUI/StatusPage/HeadOwnStatus.dart';
import 'package:chatapp/View/CustomUI/StatusPage/OthersStatusWidget.dart';
import 'package:chatapp/ViewModel/StatusPage/OthersStatusListViewModel.dart';
import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  OthersStatusListViewModel othersStatusListViewModel =
      OthersStatusListViewModel();
  List<OthersStatusModel> otherStatusList = [];

  @override
  void initState() {
    super.initState();
    getFriendStatus();
  }

  void getFriendStatus() async {
    List<OthersStatusModel> data =
        await othersStatusListViewModel.getFriendStatus();
    setState(() {
      otherStatusList = data;
    });
  }

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
            for (var item in otherStatusList)
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
