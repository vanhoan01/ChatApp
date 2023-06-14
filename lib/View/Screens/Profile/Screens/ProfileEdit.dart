// ignore_for_file: file_names

import 'package:chatapp/Model/Model/userModel.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/View/Screens/Image/ImageViewScreen.dart';
import 'package:chatapp/View/Screens/Profile/Screens/BiographyEditScreen.dart';
import 'package:chatapp/View/Screens/Profile/Screens/ChatIDEditScreen.dart';
import 'package:chatapp/View/Screens/Profile/Screens/LinkEditScreen.dart';
import 'package:chatapp/View/Screens/Profile/Screens/NameEditScreen.dart';
import 'package:chatapp/ViewModel/UserViewModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});
  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final ImagePicker _picker = ImagePicker();
  late PickedFile _imageFile;
  UserViewModel userViewModel = UserViewModel();
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
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
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Sửa hồ sơ",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            InkWell(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: TextButton(
                              onPressed: () {},
                              child: avatarOption("Chụp ảnh"),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                chooseFromLibrary();
                              },
                              child: avatarOption("Chọn từ thư viện"),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImageViewScreen(
                                        path: userModel != null
                                            ? userModel!.avatarImage ?? ""
                                            : ""),
                                  ),
                                );
                              },
                              child: avatarOption("Xem ảnh"),
                            ),
                          ),
                          Container(
                            height: 7,
                            color: Colors.grey.shade200,
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Hủy',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                backgroundImage: NetworkImage(
                    "${AppUrl.imageUrl}${userModel != null ? userModel!.avatarImage : ""}"),
                radius: 55,
                child: const CircleAvatar(
                  backgroundColor: Colors.black38,
                  radius: 55,
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Thay đổi ảnh",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 15),
            TitleItem("Giới thiệu về bạn"),
            const SizedBox(height: 5),
            OptionItem('Tên', userModel != null ? userModel!.displayName : "",
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NameEditScreen(
                    displayName:
                        userModel != null ? userModel!.displayName : "",
                  ),
                ),
              ).then((value) => getUser());
            }),
            OptionItem('Chat ID', userModel != null ? userModel!.userName : "",
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatIDEditScreen(
                    chatID: userModel != null ? userModel!.userName : "",
                  ),
                ),
              ).then((value) => getUser());
            }),
            OptionItem(
                'Tiểu sử', userModel != null ? userModel!.biography ?? "" : "",
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BiographyEditScreen(
                    biography:
                        userModel != null ? userModel!.biography ?? "" : "",
                  ),
                ),
              ).then((value) => getUser());
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                height: 1,
                color: Colors.grey.shade400,
              ),
            ),
            TitleItem("Liên kết"),
            OptionItem(
                'Liên kết', userModel != null ? userModel!.link ?? "" : "", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LinkEditScreen(
                    link: userModel != null ? userModel!.link ?? "" : "",
                  ),
                ),
              ).then((value) => getUser());
            }),
          ],
        ),
      ),
    );
  }

  Future<void> chooseFromLibrary() async {
    // ignore: deprecated_member_use
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
      // ignore: avoid_print
      print("pickedFile!.path: ${pickedFile.path}");
      await UserViewModel().updateAvatarImage(_imageFile);
      getUser();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  Widget avatarOption(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget TitleItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget OptionItem(String leading, String title, Function() function) {
    return ListTile(
      onTap: function,
      dense: true,
      leading: Text(
        leading,
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        maxLines: 1,
        textAlign: TextAlign.right,
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
