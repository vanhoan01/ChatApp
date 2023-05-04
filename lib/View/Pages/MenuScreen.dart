// ignore_for_file: file_names

import 'package:chatapp/Model/Model/userModel.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/View/Profile/ProfilePage.dart';
import 'package:chatapp/ViewModel/Profile/UserViewModel.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  UserViewModel userViewModel = UserViewModel();
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    UserModel data = await userViewModel.getUserModel();
    setState(() {
      userModel = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Tùy chọn"),
      ),
      body: ListView(children: [
        // UserItem(),
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (builder) => const ProfilePage(),
        ),
      ).then((value) => getUser()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
                "${AppUrl.imageUrl}${userModel == null ? "" : userModel!.avatarImage}"),
          ),
          title: Text(
            userModel == null ? "" : userModel!.displayName,
            style: const TextStyle(
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
