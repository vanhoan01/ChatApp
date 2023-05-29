// ignore_for_file: file_names

import 'package:chatapp/Model/Model/OthersStatusModel.dart';
import 'package:chatapp/View/Components/CustomUI/StatusPage/OthersStatusWidget.dart';
import 'package:chatapp/ViewModel/StatusPage/OthersStatusListViewModel.dart';
import 'package:flutter/material.dart';

class FriendTab extends StatefulWidget {
  const FriendTab({super.key});

  @override
  State<FriendTab> createState() => _FriendTabState();
}

class _FriendTabState extends State<FriendTab> {
  OthersStatusListViewModel othersStatusListViewModel =
      OthersStatusListViewModel();
  List<OthersStatusModel> _otherStatusList = [];

  @override
  void initState() {
    super.initState();
    getFriendStatus();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() async {
          print("object");
          await getFriendStatus();
        });
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            // const HeadOwnStatus(),
            label(
                "Đang hoạt động (${_otherStatusList.where((e) => e.precense == "Hoạt động").length})"),
            for (var item in _otherStatusList)
              if (item.precense == "Hoạt động")
                OthersStatusWidget(
                  othersStatusModel: item,
                ),
            const SizedBox(height: 10),
            label(
                "Không hoạt động (${_otherStatusList.where((e) => e.precense != "Hoạt động").length})"),
            for (var item in _otherStatusList)
              if (item.precense != "Hoạt động")
                OthersStatusWidget(
                  othersStatusModel: item,
                ),
          ],
        ),
      ),
    );
  }

  Future<void> getFriendStatus() async {
    List<OthersStatusModel> data =
        await othersStatusListViewModel.getFriendStatus();
    // NavigationService.instance.navigationKey.currentContext ?? context,
    setState(() {
      _otherStatusList = data;
    });
  }

  Widget label(String lablename) {
    return SizedBox(
      height: 33,
      width: MediaQuery.of(context).size.width,
      // color: Colors.white,
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
