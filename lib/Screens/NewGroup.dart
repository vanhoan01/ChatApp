// ignore_for_file: file_names

import 'package:chatapp/CustomUI/AvtarCardItem.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Screens/Homescreen.dart';
import 'package:chatapp/Services/metwork_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewGroup extends StatefulWidget {
  const NewGroup({Key? key, required this.groups}) : super(key: key);
  final List<ChatModel> groups;

  @override
  State<NewGroup> createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();
  ImagePicker _picker = ImagePicker();
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
          children: [
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
          SizedBox(
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
                  SizedBox(
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
          SizedBox(height: 10),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => Homescreen(),
              //IndividuaPage
            ),
          );
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
                child: Icon(
                  iconphoto,
                  color: Colors.white,
                ),
                backgroundColor: Colors.teal,
              ),
            ),
          ),
        ),
        maxLength: 100,
        maxLines: null,
      ),
    );
  }

  Widget addButton() {
    return InkWell(
      onTap: () async {
        if (_imageFile != null && _globalkey.currentState!.validate()) {
          // AddBlogModel addBlogModel =
          //     AddBlogModel(body: _body.text, title: _title.text);
          // var response = await networkHandler.post1(
          //     "/blogpost/Add", addBlogModel.toJson());
          // print(response.body);

          // if (response.statusCode == 200 || response.statusCode == 201) {
          //   String id = json.decode(response.body)["data"];
          //   var imageResponse = await networkHandler.patchImage(
          //       "/blogpost/add/coverImage/$id", _imageFile.path);
          //   print(imageResponse.statusCode);
          //   if (imageResponse.statusCode == 200 ||
          //       imageResponse.statusCode == 201) {
          //     Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(builder: (context) => HomePage()),
          //         (route) => false);
          //   }
          // }
        }
      },
      child: Center(
        child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.teal),
          child: Center(
              child: Text(
            "Add Blog",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  void takeCoverPhoto() async {
    final coverPhoto = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = coverPhoto!;
      iconphoto = Icons.check_sharp;
    });
  }
}
