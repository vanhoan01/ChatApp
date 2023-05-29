// ignore_for_file: file_names

import 'package:chatapp/Model/Model/OthersStatusModel.dart';
import 'package:chatapp/View/Components/CustomUI/StatusPage/OthersStatusWidget.dart';
import 'package:chatapp/ViewModel/StatusPage/OthersStatusListViewModel.dart';
import 'package:flutter/material.dart';

class FriendRequest extends StatefulWidget {
  const FriendRequest({super.key});

  @override
  State<FriendRequest> createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  OthersStatusListViewModel othersStatusListViewModel =
      OthersStatusListViewModel();
  List<OthersStatusModel> _otherStatusList = [];

  @override
  void initState() {
    super.initState();
    getFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() async {
          print("object");
          await getFriendRequests();
        });
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            // const HeadOwnStatus(),
            for (var item in _otherStatusList)
              OthersStatusWidget(
                othersStatusModel: item,
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> getFriendRequests() async {
    List<OthersStatusModel> data =
        await othersStatusListViewModel.getFriendRequests();
    // NavigationService.instance.navigationKey.currentContext ?? context,

    setState(() {
      _otherStatusList = data;
    });
  }
}
