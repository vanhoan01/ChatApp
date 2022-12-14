// ignore_for_file: file_names

import 'dart:convert';
import 'package:chatapp/CustomUI/OwnFileCard.dart';
import 'package:chatapp/CustomUI/OwnMessageCard.dart';
import 'package:chatapp/CustomUI/ReplyCard.dart';
import 'package:chatapp/CustomUI/ReplyFileCard.dart';
import 'package:chatapp/Model/ChatMessagesModel.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Model/ListChatMessagesModel.dart';
import 'package:chatapp/Model/userModel.dart';
import 'package:chatapp/Screens/CameraScreen.dart';
import 'package:chatapp/Screens/CameraViewPage.dart';
import 'package:chatapp/Screens/Homescreen.dart';
import 'package:chatapp/Services/metwork_handler.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

class IndividualPage extends StatefulWidget {
  const IndividualPage({Key? key, required this.chatModel}) : super(key: key);
  final ChatModel chatModel;

  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  ChatModel? sourceChat;
  late IO.Socket socket;
  final TextEditingController _textEditingController = TextEditingController();
  bool sendButton = false;
  late List<ChatMessagesModel> messages = [];
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  late XFile file;
  int popTime = 0;
  late String relationship = "";

  NetworkHandler networkHandler = NetworkHandler();
  late String _url = "";
  ListChatMessagesModel listChatMessagesModel = ListChatMessagesModel();

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
    fetchData();

    super.initState();
    _url = networkHandler.getURL();
    connect();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
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
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Homescreen()),
                    (route) => false);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_back),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: widget.chatModel.avatarImage.isNotEmpty
                        ? NetworkImage(
                            "$_url/uploads/${widget.chatModel.avatarImage}",
                          )
                        : null,
                    backgroundColor: Colors.blueGrey,
                    child: widget.chatModel.avatarImage.isEmpty
                        ? SvgPicture.asset(
                            widget.chatModel.isGroup
                                ? 'assets/groups.svg'
                                : 'assets/person.svg',
                            color: Colors.white,
                            height: 37,
                            width: 37,
                          )
                        : Container(),
                  )
                ],
              ),
            ),
            title: InkWell(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chatModel.displayName,
                      style: const TextStyle(
                          fontSize: 18.5, fontWeight: FontWeight.bold),
                    ),
                    const Text(
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
                icon: const Icon(Icons.videocam),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call),
              ),
              PopupMenuButton<String>(
                offset: const Offset(-20, 45),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                onSelected: (value) {
                  print(value);
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(
                      value: 'View Contact',
                      child: Text('View Contact'),
                    ),
                    const PopupMenuItem(
                      value: 'Media, links and docs',
                      child: Text('Media, links and docs'),
                    ),
                    const PopupMenuItem(
                      value: 'Whatsapp Web',
                      child: Text('Whatsapp Web'),
                    ),
                    const PopupMenuItem(
                      value: 'Search',
                      child: Text('Search'),
                    ),
                    const PopupMenuItem(
                      value: 'Mute Notification',
                      child: Text('Mute Notification'),
                    ),
                    const PopupMenuItem(
                      value: 'Wallpaper',
                      child: Text('Wallpaper'),
                    ),
                  ];
                },
              ),
            ],
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.height,
            child: WillPopScope(
              child: Column(
                children: [
                  relationship == "B???n b??" || widget.chatModel.isGroup == true
                      ? Container()
                      : ketBan(),
                  Expanded(
                    // height: MediaQuery.of(context).size.height - 140,
                    child: ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      controller: _scrollController,
                      itemCount: messages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == messages.length) {
                          return Container(
                            height: 70,
                          );
                        }
                        if (messages[index].author == sourceChat!.userName) {
                          if (messages[index].image.isNotEmpty) {
                            return OwnFileCard(
                              path: messages[index].image,
                              message: messages[index].text,
                              time: messages[index]
                                  .timestamp
                                  .toString()
                                  .substring(10, 16),
                            );
                          } else {
                            return OwnMessageCard(
                              message: messages[index].text,
                              time: messages[index]
                                  .timestamp
                                  .toString()
                                  .substring(10, 16),
                            );
                          }
                        } else {
                          if (messages[index].image.isNotEmpty) {
                            return ReplyFileCard(
                              avartar: widget.chatModel.isGroup
                                  ? getAvartar(messages[index].author)
                                      .toString()
                                  : widget.chatModel.avatarImage,
                              path: messages[index].image,
                              message: messages[index].text,
                              time: messages[index]
                                  .timestamp
                                  .toString()
                                  .substring(10, 16),
                              isGroup: widget.chatModel.isGroup,
                            );
                          } else {
                            return ReplyCard(
                              path: widget.chatModel.isGroup
                                  ? getAvartar(messages[index].author)
                                      .toString()
                                  : widget.chatModel.avatarImage,
                              message: messages[index].text,
                              time: messages[index]
                                  .timestamp
                                  .toString()
                                  .substring(10, 16),
                              isGroup: widget.chatModel.isGroup,
                            );
                          }
                        }
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 60,
                                child: Card(
                                  // ignore: prefer_const_constructors
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
                                      if (value.isNotEmpty) {
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
                                      contentPadding: const EdgeInsets.all(5),
                                      prefixIcon: IconButton(
                                        icon: const Icon(Icons.emoji_emotions),
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
                                            icon: const Icon(Icons.attach_file),
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
                                            icon: const Icon(Icons.camera_alt),
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
                                  backgroundColor: const Color(0xFF128C7E),
                                  child: IconButton(
                                    onPressed: () {
                                      if (sendButton) {
                                        // _scrollController.animateTo(
                                        //     _scrollController
                                        //         .position.maxScrollExtent,
                                        //     duration: const Duration(
                                        //         milliseconds: 300),
                                        //     curve: Curves.easeOut);
                                        sendMessage(
                                          _textEditingController.text,
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

  Future<String> getAvartar(String userName) async {
    var responseAvartar = await networkHandler.get("/user/get/image/$userName");
    // ignore: unnecessary_null_comparison
    if (responseAvartar.toString() == null) {
      return "";
    }
    return responseAvartar.toString();
  }

  void fetchData() async {
    var responseUser = await networkHandler.get("/user/getData");
    UserModel userModel = UserModel.fromJson(responseUser);
    print(userModel);
    setState(() {
      sourceChat = ChatModel(
          userName: userModel.username,
          displayName: userModel.displayName,
          avatarImage:
              userModel.avatarImage == null ? "" : userModel.avatarImage!,
          isGroup: false,
          timestamp: '03:00',
          currentMessage: 'currentMessage');
    });
    Map<String, String> body = {"partition": widget.chatModel.userName};
    String urlChat = widget.chatModel.isGroup
        ? "/chatmessage/get/messagesgroup"
        : "/chatmessage/get/messages";
    var responseChatMessage = await networkHandler.getpost(urlChat, body);
    List<ChatMessagesModel>? listChatMessages1 = [];
    if (true) {
      listChatMessagesModel =
          ListChatMessagesModel.fromJson(responseChatMessage);
      var listChatMessages = listChatMessagesModel.data;
      print(listChatMessages);
      listChatMessages1 = listChatMessages;
    }
    print(listChatMessages1);
    var relation = await networkHandler
        .get("/user/get/relationship/${widget.chatModel.userName}");
    print(widget.chatModel.userName);
    print(relation);

    setState(() {
      messages = listChatMessages1!;
      relationship = relation.toString();
    });
  }

  Future<void> connect() async {
    socket = IO.io(_url, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    await socket.connect();
    socket.emit("signin", sourceChat!.userName);
    socket.onConnect((data) {
      print("Connected");
      socket.on("message", (msg) {
        print(msg);
        setMessage(
          msg["message"],
          msg["path"],
        );
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    });
    // ignore: avoid_print
    print(socket.connected);
  }

  Future<void> sendMessage(String text, String image) async {
    //database
    Map<String, String> data = {
      "author": sourceChat!.userName,
      "partition": widget.chatModel.userName,
      "isGroup": widget.chatModel.isGroup.toString(),
      "text": text,
      "image": image
    };
    var responseSend = await networkHandler.post("/chatmessage/add", data);
    print(responseSend);

    //socket
    setMessage(text, image);
    socket.emit("message", {
      "message": text,
      "sourceId": sourceChat!.userName,
      "targetId": widget.chatModel.isGroup,
      "path": image,
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

    //add Image
    var request =
        http.MultipartRequest("POST", Uri.parse("${_url}/image/addimage"));
    request.files.add(await http.MultipartFile.fromPath("img", path));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
    });
    http.StreamedResponse response = await request.send();
    var httpResponse = await http.Response.fromStream(response);
    var data = json.decode(httpResponse.body);
    print(data['path']);

    //send DB
    Map<String, String> dataMap = {
      "author": sourceChat!.userName,
      "partition": widget.chatModel.userName,
      "isGroup": widget.chatModel.isGroup.toString(),
      "text": message,
      "image": data['path']
    };
    var responseSend = await networkHandler.post("/chatmessage/add", dataMap);
    print(responseSend);

    //send Socket
    setMessage(message, path);
    socket.emit("message", {
      "message": message,
      "sourceId": sourceChat!.userName,
      "targetId": widget.chatModel.userName,
      "path": data['path'],
    });
  }

  void setMessage(String text, String image) {
    ChatMessagesModel messageModel = ChatMessagesModel(
      author: sourceChat!.userName,
      partition: widget.chatModel.userName,
      text: text,
      image: image,
      timestamp: DateTime.now(),
      // DateTime.now().toString().substring(10, 16),
    );
    setState(() {
      messages.insert(0, messageModel);
    });
  }

  Future<void> setRelationship(String userRela, String chatterRela) async {
    var responseCheck = await networkHandler
        .get("/user/checkrelationship/${widget.chatModel.userName}");
    print(responseCheck['status']);
    var body = {
      "userName": sourceChat!.userName,
      "relationship": {
        "userName": widget.chatModel.userName,
        "typeStatus": userRela
      }
    };
    var body1 = {
      "userName": widget.chatModel.userName,
      "relationship": {
        "userName": sourceChat!.userName,
        "typeStatus": chatterRela
      }
    };
    if (responseCheck['status'] == false) {
      var response = await networkHandler.post1("/user/add/relationship", body);
      print(response);
      var response1 =
          await networkHandler.post1("/user/add/relationship", body1);
      print(response1);
    } else {
      var response =
          await networkHandler.post1("/user/update/relationship", body);
      print(response);
      var response1 =
          await networkHandler.post1("/user/update/relationship", body1);
      print(response1);
    }
  }

  Widget ketBan() {
    return InkWell(
      onTap: () async {
        if (relationship == "K???t b???n") {
          setRelationship("???? g???i l???i m???i k???t b???n", "Ch???p nh???n");
          setState(() {
            relationship = "???? g???i l???i m???i k???t b???n";
          });
        } else {
          if (relationship == "Ch???p nh???n") {
            setRelationship("B???n b??", "B???n b??");
            setState(() {
              relationship = "B???n b??";
            });
          } else {
            if (relationship == "???? g???i l???i m???i k???t b???n") {
              setRelationship("Ng?????i l???", "Ng?????i l???");
              setState(() {
                relationship = "K???t b???n";
              });
            }
          }
        }
      },
      child: Container(
        color: Colors.white,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_alt_outlined,
              color: Colors.grey,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              relationship == "Ng?????i l???" ? "K???t b???n" : relationship,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomsheet() {
    return SizedBox(
      height: 276,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconcreation(Icons.insert_drive_file, Colors.indigo,
                      'Document', () {}),
                  const SizedBox(width: 40),
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
                  const SizedBox(width: 40),
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
                      // ignore: use_build_context_synchronously
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
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconcreation(Icons.headset, Colors.orange, 'Audio', () {}),
                  const SizedBox(width: 40),
                  iconcreation(
                      Icons.location_pin, Colors.teal, 'Location', () {}),
                  const SizedBox(width: 40),
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
          const SizedBox(height: 5),
          Text(
            text,
            style: const TextStyle(
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
            config: const Config(
                columns: 7,
                // Issue: https://github.com/flutter/flutter/issues/28894
                emojiSizeMax: 32,
                verticalSpacing: 0,
                horizontalSpacing: 0,
                gridPadding: EdgeInsets.zero,
                initCategory: Category.RECENT,
                bgColor: Color(0xFFF2F2F2),
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
                noRecents: Text(
                  'No Recents',
                  style: TextStyle(fontSize: 20, color: Colors.black26),
                  textAlign: TextAlign.center,
                ),
                tabIndicatorAnimDuration: kTabScrollDuration,
                categoryIcons: CategoryIcons(),
                buttonMode: ButtonMode.MATERIAL)),
      ),
    );
  }
}
