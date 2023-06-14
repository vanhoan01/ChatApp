// ignore_for_file: file_names

import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/View/Screens/Profile/GroupProfileScreen.dart';
import 'package:chatapp/View/Screens/Profile/OtherProfileScreen.dart';
import 'package:flutter/material.dart';

class InformationUser extends StatefulWidget {
  const InformationUser({
    super.key,
    required this.userName,
    required this.displayName,
    required this.avatarImage,
    required this.isGroup,
    required this.myUserName,
  });

  final String userName;
  final String displayName;
  final String avatarImage;
  final bool isGroup;
  final String myUserName;
  @override
  State<InformationUser> createState() => _InformationUserState();
}

class _InformationUserState extends State<InformationUser> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("userName: ${widget.userName}");
    print("isGroup: ${widget.isGroup}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            height: 0.5,
            color: Colors.grey.shade400,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.navigate_before,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Chi tiết",
          style: TextStyle(
              fontWeight: FontWeight.w600, color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserItem(context),
            Container(
              height: 0.5,
              width: double.infinity,
              color: Colors.grey.shade400,
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            ),
            actionTile(Icons.image, 'Xem file phương tiện, file & liên kết'),
            actionTile(Icons.block, 'Chặn'),
            // actionTile(Icons.image, 'Tìm kiếm trong cuộc trò chuyện'),
          ],
        ),
      ),
    );
  }

  Widget actionButton(IconData icon, String text, Function() function) {
    return InkWell(
      child: SizedBox(
        width: 85,
        child: Column(
          children: [
            FloatingActionButton(
              mini: true,
              backgroundColor: Colors.grey[200],
              onPressed: function,
              child: Icon(
                icon,
                size: 19,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              text,
              style: const TextStyle(
                fontSize: 11.5,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget UserItem(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => widget.isGroup
                ? GroupProfileScreen(
                    id: widget.userName, myUserName: widget.myUserName)
                : OtherProfileScreen(
                    userName: widget.userName, myUserName: widget.myUserName),
          ),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          backgroundImage:
              NetworkImage("${AppUrl.imageUrl}${widget.avatarImage}"),
        ),
        title: Text(
          widget.displayName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        subtitle: const Text(
          "Xem hồ sơ",
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        trailing: const Icon(
          Icons.navigate_next,
          size: 26,
        ),
      ),
    );
  }

  Widget actionTile(IconData? icon, String text) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        height: 45,
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            icon != null
                ? CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      iconSize: 18,
                      icon: Icon(icon, color: Colors.black),
                      onPressed: () {
                        setState(
                          () {},
                        );
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget groupTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
