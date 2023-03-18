// ignore_for_file: file_names

import 'package:chatapp/Model/Model/userModel.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/View/Profile/Screens/ProfileEdit.dart';
import 'package:chatapp/ViewModel/Profile/UserViewModel.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserViewModel userViewModel = UserViewModel();
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    UserModel data = await userViewModel.getFriendStatus();
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
            Text(
              userModel != null ? userModel!.biography ?? "" : "",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),
            OptionItem(Icons.people_outlined, "500 người bạn"),
            OptionItem(
                Icons.link, userModel != null ? userModel!.link ?? "" : ""),
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
      horizontalTitleGap: 0,
      // dense: true,
      // contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: -10),
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
    );
  }
}
