import 'dart:convert';
import 'package:chatapp/CustomUI/OwnFileCard.dart';
import 'package:chatapp/CustomUI/OwnMessageCard.dart';
import 'package:chatapp/CustomUI/ReplyCard.dart';
import 'package:chatapp/CustomUI/ReplyFileCard.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Model/MessageModel.dart';
import 'package:chatapp/Screens/CameraScreen.dart';
import 'package:chatapp/Screens/CameraViewPage.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

class IndividualPage extends StatefulWidget {
  const IndividualPage(
      {Key? key, required this.chatModel, required this.sourchat})
      : super(key: key);
  final ChatModel chatModel;
  final ChatModel sourchat;

  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  late IO.Socket socket;
  TextEditingController _textEditingController = TextEditingController();
  bool sendButton = false;
  late List<MessageModel> messages = [];
  ScrollController _scrollController = ScrollController();
  ImagePicker _picker = ImagePicker();
  late XFile file;
  int popTime = 0;

  _onEmojiSelected(Emoji emoji) {
    _textEditingController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _textEditingController.text.length));
  }

  _onBackspacePressed() {
    _textEditingController
      ..text = _textEditingController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _textEditingController.text.length));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connect();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }

// enigmatic-crag-66260.herokuapp.com
  void connect() {
    socket = IO.io("http://192.168.1.2:5000/", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.emit("signin", widget.sourchat.id);
    socket.onConnect((data) {
      print("Connected");
      socket.on("message", (msg) {
        print(msg);
        setMessage(
          "destination",
          msg["message"],
          msg["path"],
        );
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    });
    print(socket.connected);
  }

  void sendMessage(String message, int sourceId, int targetId, String path) {
    setMessage("source", message, path);
    socket.emit("message", {
      "message": message,
      "sourceId": sourceId,
      "targetId": targetId,
      "path": path,
    });
  }

  void setMessage(String type, String message, String path) {
    MessageModel messageModel = MessageModel(
      message: message,
      type: type,
      time: DateTime.now().toString().substring(10, 16),
      path: path,
    );
    setState(() {
      messages.add(messageModel);
    });
  }

  void onImageSend(String path, String message) async {
    print("Hey there working $message");
    for (var i = 0; i < popTime; i++) {
      Navigator.pop(context);
    }
    setState(() {
      popTime = 0;
    });
    var request = http.MultipartRequest(
        "POST", Uri.parse("http://192.168.1.2:5000/routes/addimage"));
    request.files.add(await http.MultipartFile.fromPath("img", path));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
    });
    http.StreamedResponse response = await request.send();

    var httpResponse = await http.Response.fromStream(response);
    var data = json.decode(httpResponse.body);
    print(data['path']);
    setMessage("source", message, path);
    socket.emit("message", {
      "message": message,
      "sourceId": widget.sourchat.id,
      "targetId": widget.chatModel.id,
      "path": data['path'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/whatsapp_Back.png',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leadingWidth: 70,
            titleSpacing: 0,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back),
                  CircleAvatar(
                    child: SvgPicture.asset(
                      widget.chatModel.isGroup
                          ? 'assets/groups.svg'
                          : 'assets/person.svg',
                      color: Colors.white,
                      height: 37,
                      width: 37,
                    ),
                    radius: 20,
                    backgroundColor: Colors.blueGrey,
                  )
                ],
              ),
            ),
            title: InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chatModel.name,
                      style: TextStyle(
                          fontSize: 18.5, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Last seen today at 12:06',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.videocam),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.call),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  print(value);
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: Text('View Contact'),
                      value: 'View Contact',
                    ),
                    PopupMenuItem(
                      child: Text('Media, links and docs'),
                      value: 'Media, links and docs',
                    ),
                    PopupMenuItem(
                      child: Text('Whatsapp Web'),
                      value: 'Whatsapp Web',
                    ),
                    PopupMenuItem(
                      child: Text('Search'),
                      value: 'Search',
                    ),
                    PopupMenuItem(
                      child: Text('Mute Notification'),
                      value: 'Mute Notification',
                    ),
                    PopupMenuItem(
                      child: Text('Wallpaper'),
                      value: 'Wallpaper',
                    ),
                  ];
                },
              ),
            ],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.height,
            child: WillPopScope(
              child: Column(
                children: [
                  Expanded(
                    // height: MediaQuery.of(context).size.height - 140,
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: messages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == messages.length) {
                          return Container(
                            height: 70,
                          );
                        }
                        if (messages[index].type == "source") {
                          if (messages[index].path.length > 0) {
                            return OwnFileCard(
                              path: messages[index].path,
                              message: messages[index].message,
                              time: messages[index].time,
                            );
                          } else {
                            return OwnMessageCard(
                              message: messages[index].message,
                              time: messages[index].time,
                            );
                          }
                        } else {
                          if (messages[index].path.length > 0) {
                            return ReplyFileCard(
                              path: messages[index].path,
                              message: messages[index].message,
                              time: messages[index].time,
                            );
                          } else {
                            return ReplyCard(
                              message: messages[index].message,
                              time: messages[index].time,
                            );
                          }
                        }
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 60,
                                child: Card(
                                  margin: EdgeInsets.only(
                                      left: 2, right: 2, bottom: 8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  child: TextFormField(
                                    controller: _textEditingController,
                                    focusNode: focusNode,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.multiline,
                                    maxLength: 100,
                                    minLines: 1,
                                    maxLines: 3,
                                    onChanged: (value) {
                                      if (value.length > 0) {
                                        setState(() {
                                          sendButton = true;
                                        });
                                      } else {
                                        setState(() {
                                          sendButton = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Type of message',
                                      counterText: "",
                                      contentPadding: EdgeInsets.all(5),
                                      prefixIcon: IconButton(
                                        icon: Icon(Icons.emoji_emotions),
                                        onPressed: () {
                                          focusNode.unfocus();
                                          focusNode.canRequestFocus = false;
                                          setState(() {
                                            show = !show;
                                          });
                                        },
                                      ),
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: (builder) =>
                                                      bottomsheet());
                                            },
                                            icon: Icon(Icons.attach_file),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                popTime = 2;
                                              });
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (builder) =>
                                                      CameraScreen(
                                                    onImageSend: onImageSend,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: Icon(Icons.camera_alt),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8, right: 5, left: 2),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Color(0xFF128C7E),
                                  child: IconButton(
                                    onPressed: () {
                                      if (sendButton) {
                                        _scrollController.animateTo(
                                            _scrollController
                                                .position.maxScrollExtent,
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeOut);
                                        sendMessage(
                                          _textEditingController.text,
                                          widget.sourchat.id,
                                          widget.chatModel.id,
                                          "",
                                        );
                                        _textEditingController.clear();
                                        setState(() {
                                          sendButton = false;
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      sendButton ? Icons.send : Icons.mic,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          show ? emojiSelect() : Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              onWillPop: () {
                if (show) {
                  setState(() {
                    show = false;
                  });
                } else {
                  Navigator.pop(context);
                }
                return Future.value(false);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomsheet() {
    return Container(
      height: 276,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconcreation(Icons.insert_drive_file, Colors.indigo,
                      'Document', () {}),
                  SizedBox(width: 40),
                  iconcreation(
                    Icons.camera_alt,
                    Colors.pink,
                    'Camera',
                    () {
                      setState(() {
                        popTime = 3;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => CameraScreen(
                            onImageSend: onImageSend,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 40),
                  iconcreation(
                    Icons.insert_photo,
                    Colors.purple,
                    'Gallery',
                    () async {
                      setState(() {
                        popTime = 2;
                      });
                      file = (await _picker.pickImage(
                          source: ImageSource.gallery))!;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => CameraViewPage(
                            path: file.path,
                            onImageSend: onImageSend,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconcreation(Icons.headset, Colors.orange, 'Audio', () {}),
                  SizedBox(width: 40),
                  iconcreation(
                      Icons.location_pin, Colors.teal, 'Location', () {}),
                  SizedBox(width: 40),
                  iconcreation(Icons.person, Colors.blue, 'Contact', () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconcreation(
      IconData icon, Color color, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icon,
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget emojiSelect() {
    return Offstage(
      offstage: !show,
      child: SizedBox(
        height: 250,
        child: EmojiPicker(
            onEmojiSelected: (Category category, Emoji emoji) {
              _onEmojiSelected(emoji);
            },
            onBackspacePressed: _onBackspacePressed,
            config: Config(
                columns: 7,
                // Issue: https://github.com/flutter/flutter/issues/28894
                emojiSizeMax: 32,
                verticalSpacing: 0,
                horizontalSpacing: 0,
                gridPadding: EdgeInsets.zero,
                initCategory: Category.RECENT,
                bgColor: const Color(0xFFF2F2F2),
                indicatorColor: Colors.blue,
                iconColor: Colors.grey,
                iconColorSelected: Colors.blue,
                progressIndicatorColor: Colors.blue,
                backspaceColor: Colors.blue,
                skinToneDialogBgColor: Colors.white,
                skinToneIndicatorColor: Colors.grey,
                enableSkinTones: true,
                showRecentsTab: true,
                recentsLimit: 28,
                replaceEmojiOnLimitExceed: false,
                noRecents: const Text(
                  'No Recents',
                  style: TextStyle(fontSize: 20, color: Colors.black26),
                  textAlign: TextAlign.center,
                ),
                tabIndicatorAnimDuration: kTabScrollDuration,
                categoryIcons: const CategoryIcons(),
                buttonMode: ButtonMode.MATERIAL)),
      ),
    );
  }
}
