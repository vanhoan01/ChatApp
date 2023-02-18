// ignore_for_file: file_names

import 'package:chatapp/View/Profile/ProfilePage.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        UserItem(),
        OptionItem(Icons.account_tree_outlined, Colors.purple,
            "Chuyển tài khoản", null),
        OptionItem(
            Icons.circle, Colors.green, "Trạng thái hoạt động", 'Đang bật'),
        OptionItem(Icons.alternate_email_outlined, Colors.red, "Tên người dùng",
            'm.me/nguyenvanhoan.1201'),
        TitleItem("Tùy chọn"),
        OptionItem(Icons.report_problem, Colors.orange,
            "Báo cáo sự cố kỹ thuật", null),
        OptionItem(Icons.help, Colors.blue, "Trợ giúp", null),
        OptionItem(
            Icons.document_scanner, Colors.grey, "Pháp lý & chính sách", null),
      ]),
    );
  }

  // ignore: non_constant_identifier_names
  Widget UserItem() {
    return InkWell(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (builder) => const ProfilePage())),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage("assets/balram.jpg"),
          ),
          title: Text(
            "Nguyễn Văn Hoàn",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget OptionItem(
      IconData iconData, Color color, String title, String? subtitle) {
    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: color,
        child: Icon(
          iconData,
          color: Colors.white,
          size: 18,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.w500, color: Colors.black, fontSize: 15),
      ),
      // ignore: unnecessary_null_comparison
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            )
          : null,
    );
  }

  // ignore: non_constant_identifier_names
  Widget TitleItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(
        text,
        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
      ),
    );
  }
}
