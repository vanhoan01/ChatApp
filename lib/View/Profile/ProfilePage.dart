// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
            Stack(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://topplus.vn/Userfiles/Upload/images/Download/2016/10/17/068bdc9e57db40a0ab112c56bda5f44d.jpg"),
                  radius: 55,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.greenAccent[700],
                    child: const Icon(
                      Icons.add,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "Nguyễn Văn Hoàn",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tiểu sử",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 15),
            OptionItem(Icons.people_outlined, "500 người bạn"),
            OptionItem(Icons.link, "van.hoan.ihs"),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          width: 1, color: Color.fromRGBO(224, 224, 224, 1)),
                    ),
                    child: const Text(
                      "Sửa hồ sơ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          width: 1, color: Color.fromRGBO(224, 224, 224, 1)),
                    ),
                    child: const Text(
                      "Chia sẻ hồ sơ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget OptionItem(IconData iconData, String title) {
    return ListTile(
      leading: Icon(
        iconData,
        color: Colors.grey,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
