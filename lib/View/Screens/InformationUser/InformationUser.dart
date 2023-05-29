// ignore_for_file: file_names

import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/View/Screens/Pages/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InformationUser extends StatefulWidget {
  const InformationUser(
      {super.key,
      required this.userName,
      required this.displayName,
      required this.avatarImage});

  final String userName;
  final String displayName;
  final String avatarImage;
  @override
  State<InformationUser> createState() => _InformationUserState();
}

class _InformationUserState extends State<InformationUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.black),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              backgroundImage: widget.avatarImage != null
                  ? NetworkImage(
                      "${AppUrl.imageUrl}${widget.avatarImage}",
                    )
                  : null,
              // ignore: sort_child_properties_last
              child: widget.avatarImage == null
                  ? SvgPicture.asset(
                      'assets/person.svg',
                      color: Colors.white,
                      height: 35,
                      width: 35,
                    )
                  : null,
              backgroundColor: Colors.blueGrey,
              radius: 55,
            ),
            const SizedBox(height: 10),
            Text(
              widget.displayName,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  actionButton(Icons.call, "Gọi thoại", () {}),
                  actionButton(Icons.videocam, "Gọi video", () {}),
                  actionButton(Icons.person, "Trang cá nhân", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  }),
                  actionButton(
                      Icons.notifications_rounded, "Tắt thông báo", () {}),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                groupTitle('Hành động khác'),
                actionTile(
                    Icons.image, 'Xem file phương tiện, file & liên kết'),
                actionTile(Icons.image, 'Xem tin nhắn đã ghim'),
                actionTile(Icons.image, 'Tìm kiếm trong cuộc trò chuyện'),
              ],
            ),
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
