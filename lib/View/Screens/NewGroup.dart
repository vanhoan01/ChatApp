// ignore_for_file: file_names

import 'dart:convert';

import 'package:chatapp/Model/Model/ChatModel.dart';
import 'package:chatapp/Model/Model/ChatterModel.dart';
import 'package:chatapp/Model/Model/ConversationModel.dart';
import 'package:chatapp/Model/Model/userModel.dart';
import 'package:chatapp/View/CustomUI/AvtarCardItem.dart';
import 'package:chatapp/View/Screens/IndividualPage.dart';
import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class NewGroup extends StatefulWidget {
  const NewGroup({Key? key, required this.groups}) : super(key: key);
  final List<ChatterModel> groups;

  @override
  State<NewGroup> createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  final _globalkey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _body = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late PickedFile _imageFile;
  IconData iconphoto = Icons.camera_alt;
  NetworkHandler networkHandler = NetworkHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Nhóm mới',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Thêm tiêu đề',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 70,
            color: Colors.white,
            child: Form(
              key: _globalkey,
              child: ListView(
                children: <Widget>[
                  titleTextField(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Những người tham gia: ${widget.groups.length}"),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 75,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.groups.length,
              itemBuilder: (context, index) {
                return AvtarCardItem(contact: widget.groups[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addConversation();
        },
        backgroundColor: const Color(0xFF128C7E),
        child: const Icon(Icons.check),
      ),
    );
  }

  Widget titleTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: TextFormField(
        controller: _title,
        validator: (value) {
          if (value!.isEmpty) {
            return "Tiêu đề không được để trống";
          } else if (value.length > 100) {
            return "Độ dài tiêu đề phải <=100";
          }
          return null;
        },
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.teal),
          hintText: "Tiêu đề nhóm",
          counterText: "",
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 12, bottom: 8, top: 4),
            child: InkWell(
              onTap: takeCoverPhoto,
              child: CircleAvatar(
                backgroundColor: Colors.teal,
                child: Icon(
                  iconphoto,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        maxLength: 100,
        maxLines: null,
      ),
    );
  }

  Future<void> addConversation() async {
    String avatarImage = "";
    if (_imageFile != null) {
      //add Image
      var request = http.MultipartRequest(
          "POST", Uri.parse("${networkHandler.getURL()}/image/addimage"));
      request.files
          .add(await http.MultipartFile.fromPath("img", _imageFile.path));
      request.headers.addAll({
        "Content-type": "multipart/form-data",
      });
      http.StreamedResponse response = await request.send();
      var httpResponse = await http.Response.fromStream(response);
      var data = json.decode(httpResponse.body);
      print("data: $data");
      avatarImage = data['path'];
      print("avatarImage: $avatarImage");
    }
    if (_globalkey.currentState!.validate()) {
      print("avatarImage: $avatarImage");
      var responseUser = await networkHandler.get("/user/getData");
      UserModel userModel = UserModel.fromJson(responseUser);
      var members = [
        {"userName": userModel.userName, "memberShipStatus": "Quản trị viên"}
      ];
      for (var mem in widget.groups) {
        members.add({"userName": mem.userName});
      }
      var conversationModel = {
        "displayName": _title.text,
        "avatarImage": avatarImage,
        "members": members
      };
      var response =
          await networkHandler.post1("/conversation/add", conversationModel);
      //.toJson()
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // var conver = json.decode(response.body)["data"];
        ConversationModel conversationModel =
            ConversationModel.fromJson(json.decode(response.body)['data']);
        print(conversationModel);
        ChatModel chatModel = ChatModel(
            userName: conversationModel.id,
            displayName: conversationModel.displayName,
            avatarImage: conversationModel.avatarImage,
            isGroup: true,
            timestamp: '',
            currentMessage: '');

        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => IndividualPage(
                      chatModel: chatModel,
                    )),
            (route) => false);
      }
    }
  }

  void takeCoverPhoto() async {
    // ignore: deprecated_member_use
    final coverPhoto = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = coverPhoto!;
      iconphoto = Icons.check_sharp;
    });
  }
}
