// ignore_for_file: file_names

import 'package:chatapp/Model/Model/userModel.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/View/Screens/MenuScreen.dart';
import 'package:chatapp/View/Screens/Profile/Screens/ProfileEdit.dart';
import 'package:chatapp/View/Screens/Profile/Tabs/SavedTab.dart';
import 'package:chatapp/View/Screens/Profile/Tabs/FileTab.dart';
import 'package:chatapp/View/Screens/Profile/Tabs/ImageTab.dart';
import 'package:chatapp/View/Screens/Profile/Tabs/LikeTab.dart';
import 'package:chatapp/View/Screens/SearchScreen.dart';
import 'package:chatapp/ViewModel/UserViewModel.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.userName});
  final String? userName;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  UserViewModel userViewModel = UserViewModel();
  UserModel? userModel;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    getUser();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: SearchScreen(),
            );
          },
          icon: const Icon(Icons.person_add_alt, color: Colors.black),
        ),
        centerTitle: true,
        title: Text(
          userModel != null ? userModel!.userName : "",
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          maxLines: 1,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MenuScreen(),
                ),
              );
            },
            icon: const Icon(Icons.menu, color: Colors.black),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "${AppUrl.imageUrl}${userModel != null ? userModel!.avatarImage : ""}"),
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
            Text(
              userModel != null ? userModel!.displayName : "",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            userModel != null
                ? userModel!.biography != null
                    ? Text(
                        userModel != null ? userModel!.biography ?? "" : "",
                        style: const TextStyle(fontSize: 16),
                      )
                    : const SizedBox()
                : const SizedBox(),
            const SizedBox(height: 15),
            OptionItem(Icons.people_outlined, "500 người bạn"),
            userModel != null
                ? userModel!.link != null
                    ? OptionItem(Icons.link,
                        userModel != null ? userModel!.link ?? "" : "")
                    : const SizedBox()
                : const SizedBox(),
            const SizedBox(height: 15),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 15),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileEdit(),
                        ),
                      ).then((value) => getUser());
                    },
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
            ),
            const SizedBox(height: 15),
            Column(
              children: [
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.black,
                  labelColor: Colors.black,
                  labelPadding: const EdgeInsets.all(2),
                  tabs: const [
                    Tab(text: "Ảnh Video"),
                    Tab(text: "Tệp"),
                    Tab(text: "Đã Lưu"),
                    Tab(text: "Đã Thích"),
                  ],
                ),
                SizedBox(
                  height: 500,
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      ImageTab(),
                      FileTab(),
                      SavedTab(),
                      LikeTab(),
                    ],
                  ),
                ),
              ],
            ),
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
      horizontalTitleGap: 0,
      // dense: true,
      // contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: -10),
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
    );
  }
}
