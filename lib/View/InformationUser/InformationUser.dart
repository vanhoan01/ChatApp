// ignore_for_file: file_names

import 'package:flutter/material.dart';

class InformationUser extends StatefulWidget {
  const InformationUser({super.key});

  @override
  State<InformationUser> createState() => _InformationUserState();
}

class _InformationUserState extends State<InformationUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://topplus.vn/Userfiles/Upload/images/Download/2016/10/17/068bdc9e57db40a0ab112c56bda5f44d.jpg"),
              radius: 55,
            ),
            const SizedBox(height: 10),
            const Text(
              "Sheeta",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  actionButton(Icons.call, "Gọi thoại"),
                  actionButton(Icons.videocam, "Gọi video"),
                  actionButton(Icons.person, "Trang cá nhân"),
                  actionButton(Icons.notifications_rounded, "Tắt thông báo"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                groupTitle('Tùy chỉnh'),
                actionTile(Icons.circle_outlined, 'Chủ đề'),
                actionTile(Icons.back_hand_sharp, 'Cảm xúc nhanh'),
                actionTile(null, 'Biệt danh'),
                actionTile(Icons.wordpress, 'Hiệu ứng từ ngữ'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                groupTitle('Hành động khác'),
                actionTile(
                    Icons.image, 'Xem file phương tiện, file & liên kết'),
                actionTile(Icons.image, 'Xem tin nhắn đã ghim'),
                actionTile(Icons.image, 'Tìm kiếm trong cuộc trò chuyện'),
                actionTile(Icons.image, 'Thông báo và âm thanh'),
                actionTile(
                    Icons.image, 'Xem file phương tiện, file & liên kết'),
                actionTile(Icons.image, 'Xem tin nhắn đã ghim'),
                actionTile(Icons.image, 'Tìm kiếm trong cuộc trò chuyện'),
                actionTile(Icons.image, 'Thông báo và âm thanh'),
                actionTile(
                    Icons.image, 'Xem file phương tiện, file & liên kết'),
                actionTile(Icons.image, 'Xem tin nhắn đã ghim'),
                actionTile(Icons.image, 'Tìm kiếm trong cuộc trò chuyện'),
                actionTile(Icons.image, 'Thông báo và âm thanh'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget actionButton(IconData icon, String text) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        width: 85,
        child: Column(
          children: [
            FloatingActionButton(
              mini: true,
              backgroundColor: Colors.grey[200],
              onPressed: () {},
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
