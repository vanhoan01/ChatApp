// ignore_for_file: file_names

import 'package:chatapp/Model/Model/OthersStatusModel.dart';
import 'package:chatapp/View/Components/CustomUI/StatusPage/OthersStatusWidget.dart';
import 'package:chatapp/ViewModel/StatusPage/OthersStatusListViewModel.dart';
import 'package:flutter/material.dart';

class GroupTab extends StatefulWidget {
  const GroupTab({super.key});

  @override
  State<GroupTab> createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab> {
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

  Future<void> getFriendStatus() async {
    List<OthersStatusModel> data =
        await othersStatusListViewModel.getGroupStatus();
    // NavigationService.instance.navigationKey.currentContext ?? context,
    data.sort((a, b) {
      int precenseComp = a.precense.compareTo(b.precense);
      if (precenseComp == 0) {
        return a.displayName.compareTo(b.displayName); // '-' for descending
      }
      return precenseComp;
    });
    setState(() {
      _otherStatusList = data;
    });
  }
}
