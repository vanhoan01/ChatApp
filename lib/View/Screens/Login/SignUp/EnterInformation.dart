// ignore_for_file: file_names

import 'package:chatapp/View/Screens/Pages/Homescreen.dart';
import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/ViewModel/ChatterViewModel.dart';
import 'package:chatapp/ViewModel/Image/ImageViewModel.dart';
import 'package:chatapp/ViewModel/UserViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class EnterInformation extends StatefulWidget {
  const EnterInformation({super.key, this.number, this.countryCode});
  final String? number;
  final String? countryCode;

  @override
  State<EnterInformation> createState() => _EnterInformationState();
}

class _EnterInformationState extends State<EnterInformation> {
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  final storage = const FlutterSecureStorage();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();

  bool loading = false;
  final ImagePicker _picker = ImagePicker();
  IconData iconphoto = Icons.camera_alt;
  PickedFile? _imageFile;

  ImageViewModel? imageViewModel;
  UserViewModel userViewModel = UserViewModel();
  ChatterViewModel chatterViewModel = ChatterViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Thông tin hồ sơ",
          style: TextStyle(
            color: Colors.teal[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 27,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: _globalkey,
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "Vui lòng cung cấp các thông tin sau",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: takeCoverPhoto,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    child: Icon(
                      Icons.add_a_photo,
                      size: 50,
                      color: Colors.blueGrey[500],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.teal,
                        width: 1.6,
                      ),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password can't be empty";
                      }
                      if (value == "true") {
                        return "Tài khoản đã tồn tại";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      hintText: "Nhập tài khoản",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.teal,
                        width: 1.6,
                      ),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password can't be empty";
                      }
                      if (value.length < 8) {
                        return "Password lenght must have >=8";
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      hintText: "Nhập mật khẩu",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.teal,
                        width: 1.6,
                      ),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    obscureText: true,
                    controller: _passwordController1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password can't be empty";
                      }
                      if (value.length < 8) {
                        return "Password lenght must have >=8";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      hintText: "Nhập lại mật khẩu",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.teal,
                        width: 1.6,
                      ),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 50,
                  child: TextFormField(
                    controller: _displayNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password can't be empty";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      hintText: "Nhập họ và tên",
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    // await checkUser(); &checkUser()& validate
                    await signUp();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.teal),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10)),
                  ),
                  child: loading
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          "TIẾP",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void takeCoverPhoto() async {
    // ignore: deprecated_member_use
    final coverPhoto = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = coverPhoto!;
      iconphoto = Icons.check_sharp;
    });
  }

  showAlertDialogCheck(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Kiểm tra UserName"),
      content: const Text("UserName này đã tồn tại"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> signUp() async {
    String avatarImage = "";
    if (_imageFile != null) {
      //add Image
      imageViewModel = ImageViewModel(_imageFile!);
      avatarImage = await imageViewModel!.uploadImage();
      // ignore: avoid_print
      print("avatarImage: $avatarImage");
    }
    if (_globalkey.currentState!.validate()) {
      bool checkUserName =
          await userViewModel.checkUserName(_usernameController.text);
      if (checkUserName) {
        // ignore: use_build_context_synchronously
        print("checkUserName: $checkUserName");
        setState(() {
          loading = false;
        });
        // ignore: use_build_context_synchronously
        showAlertDialogCheck(context);
      } else {
        var responseRegister = await userViewModel.register(
            _usernameController.text,
            _passwordController.text,
            _displayNameController.text,
            "${widget.countryCode}${widget.number}",
            avatarImage);

        var responseRegisterChatter = await chatterViewModel.register(
            _usernameController.text,
            _passwordController.text,
            _displayNameController.text,
            "${widget.countryCode}${widget.number}",
            avatarImage);

        //Login Logic added here
        if ((responseRegister.statusCode == 200 ||
                responseRegister.statusCode == 201) &&
            (responseRegisterChatter.statusCode == 200 ||
                responseRegisterChatter.statusCode == 201)) {
          var response = await userViewModel.login(
              _usernameController.text, _passwordController.text);
          if (response.statusCode == 200 || response.statusCode == 201) {
            Map<String, dynamic> output = json.decode(response.body);
            // ignore: avoid_print
            print(output["token"]);
            await storage.write(key: "token", value: output["token"]);
            setState(() {
              // validate = true;
              loading = false;
            });
            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const Homescreen(),
                ),
                (route) => false);
          } else if (response.statusCode == 403) {
            String output = json.decode(response.body);
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(output)));
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Netwok Error")));
          }
        }
      }
    }
  }
}
