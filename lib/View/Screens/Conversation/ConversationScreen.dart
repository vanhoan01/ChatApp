// ignore_for_file: file_names
//ghim, chuyển tiếp, gỡ, emoi
//tìm kiếm, chặn, file phương tiện, chia sẻ danh thiếp
import 'dart:convert';
import 'dart:io';
import 'package:chatapp/Model/List/ListChatMessagesModel.dart';
import 'package:chatapp/Model/Model/ChatMessagesModel.dart';
import 'package:chatapp/Model/Model/ChatModel.dart';
import 'package:chatapp/Model/Model/userModel.dart';
import 'package:chatapp/View/Components/ChatMessages/OwnMessageCard.dart';
import 'package:chatapp/View/Components/ChatMessages/ReplyMessengerCard.dart';
import 'package:chatapp/View/Screens/ChatPage/Screens/LocationShareMap.dart';
import 'package:chatapp/View/Screens/Call/VideoCallScreen.dart';
import 'package:chatapp/View/Screens/Camera/CameraScreen.dart';
import 'package:chatapp/View/Screens/Camera/CameraViewPage.dart';
import 'package:chatapp/View/Screens/Pages/Homescreen.dart';
import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/View/Screens/InformationUser/InformationUser.dart';
import 'package:chatapp/ViewModel/ChatPage/ChatMessagesViewModel.dart';
import 'package:chatapp/ViewModel/File/AudioViewModel.dart';
import 'package:chatapp/ViewModel/File/FileViewModel.dart';
import 'package:chatapp/ViewModel/UserViewModel.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key, required this.chatModel})
      : super(key: key);
  final ChatModel chatModel;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  UserModel? sourceChat;
  late IO.Socket socket;
  final TextEditingController _textEditingController = TextEditingController();
  bool sendButton = false;
  late List<ChatMessagesModel> messages = [];
  // final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  late XFile file;
  int popTime = 0;
  late String relationship = "Bạn bè";
  NetworkHandler networkHandler = NetworkHandler();
  late String _url = "";
  ListChatMessagesModel listChatMessagesModel = ListChatMessagesModel();
  Map<String, String>? reply;
  FilePickerResult? result;
  List<File>? files;
  UserViewModel userViewModel = UserViewModel();
  final ChatMessagesViewModel _chatMessagesViewModel = ChatMessagesViewModel();

  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    _url = networkHandler.getURL();
    fetchData();
    super.initState();

    // connect();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image.asset(
          //   'assets/whatsapp_Back.png',
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          //   fit: BoxFit.cover,
          // ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
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
                      MaterialPageRoute(
                          builder: (context) => const Homescreen()),
                      (route) => false);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
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
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.chatModel.displayName,
                            style: const TextStyle(
                                fontSize: 18.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const Text(
                            'Last seen today at 12:06',
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(width: 5),
                      relationship == "Bạn bè" ||
                              widget.chatModel.isGroup == true
                          ? Container()
                          : ketBan(),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoCallScreen(
                          caller: sourceChat!.userName,
                          creceiver: widget.chatModel.userName,
                          callStatus: true,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.videocam, color: Colors.black),
                ),
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(Icons.call, color: Colors.black),
                // ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InformationUser(
                            userName: widget.chatModel.userName,
                            avatarImage: widget.chatModel.avatarImage,
                            displayName: widget.chatModel.displayName),
                      ),
                    );
                  },
                  icon: const Icon(Icons.info, color: Colors.black),
                ),
              ],
            ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.height,
              child: WillPopScope(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        padding: const EdgeInsets.only(bottom: 10),
                        // controller: _scrollController,
                        itemCount: messages.length + 1,
                        itemBuilder: (context, index) {
                          if (index == messages.length) {
                            return Container(
                              height: 70,
                            );
                          }
                          if (messages[index].author == sourceChat!.userName) {
                            return OwnMessageCard(
                              chatMM: messages[index],
                              timeAfter: index < messages.length - 1
                                  ? messages[index + 1].timestamp
                                  : DateTime.parse('2020-01-01'),
                              userId: sourceChat != null
                                  ? sourceChat!.id ?? ""
                                  : "",
                              setReply: setReply,
                              userName: sourceChat != null
                                  ? sourceChat!.userName
                                  : "",
                            );
                          } else {
                            return ReplyMessengerCard(
                                userId: sourceChat != null
                                    ? sourceChat!.id ?? ""
                                    : "",
                                chatMM: messages[index],
                                timeAfter: index < messages.length - 1
                                    ? messages[index + 1].timestamp
                                    : DateTime.parse('2010-01-01'),
                                setReply: setReply);
                          }
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          reply != null
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      top: BorderSide(
                                          width: 1.0,
                                          color: Colors.grey.shade300),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Đang trả lời ${reply!['userReply']}",
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              reply!['textReply'] ?? "",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey.shade700),
                                              maxLines: 1,
                                            )
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              reply = null;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.black,
                                          ))
                                    ],
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          60,
                                      child: Card(
                                        // ignore: prefer_const_constructors
                                        margin: EdgeInsets.only(
                                            left: 2, right: 2, bottom: 8),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        color: Colors.grey.shade100,
                                        child: TextFormField(
                                          controller: _textEditingController,
                                          focusNode: focusNode,
                                          textAlignVertical:
                                              TextAlignVertical.center,
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
                                            hintText: 'Nhắn tin',
                                            counterText: "",
                                            contentPadding:
                                                const EdgeInsets.all(5),
                                            prefixIcon: IconButton(
                                              icon: const Icon(
                                                  Icons.emoji_emotions),
                                              onPressed: () {
                                                focusNode.unfocus();
                                                focusNode.canRequestFocus =
                                                    false;
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
                                                  icon: const Icon(
                                                      Icons.attach_file),
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
                                                          onImageSend:
                                                              onImageSend,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                      Icons.camera_alt),
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
                                        backgroundColor:
                                            const Color(0xFF128C7E),
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
                                                "text",
                                                _textEditingController.text,
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
                        ],
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
      ),
    );
  }

  void setReply(String id, String userReply, String textReply) {
    setState(() {
      reply = {
        'id': id,
        'userReply': userReply,
        'textReply': textReply,
      };
    });
  }

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

  void fetchData() async {
    //get tài khoản mình
    UserModel userModel = await userViewModel.getUserModel();
    setState(() {
      sourceChat = userModel;
    });
    //get tin nhắn
    List<ChatMessagesModel>? chatMessagesList = [];
    if (widget.chatModel.isGroup) {
      chatMessagesList = await ChatMessagesViewModel()
          .getMessagesGroup(widget.chatModel.userName);
    } else {
      chatMessagesList =
          await ChatMessagesViewModel().getMessages(widget.chatModel.userName);
    }

    String relation =
        await userViewModel.getRelationship(widget.chatModel.userName);

    setState(() {
      messages = chatMessagesList!;
      relationship = relation.toString();
    });

    connect();
  }

  Future<void> connect() async {
    socket = IO.io(_url, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    // ignore: await_only_futures

    if (socket.active == false) {
      // ignore: avoid_print
      print("Connecting");
      // ignore: await_only_futures
      // await socket.connect();
      // socket.emit("signin", sourceChat!.userName);
    }
    // socket.emit("signin", sourceChat!.userName);
    socket.onConnect((data) {
      // ignore: avoid_print

      socket.on("message", (msg) {
        // ignore: avoid_print
        print("nhận msg: $msg");

        setMessage(
          msg["author"],
          msg["partition"],
          msg['isGroup'],
          msg["type"],
          msg["text"],
          msg['size'],
          msg["reply"],
        );

        // if (_scrollController.hasClients) {
        //   _scrollController.animateTo(
        //       _scrollController.position.maxScrollExtent ?? 0.5,
        //       duration: const Duration(milliseconds: 300),
        //       curve: Curves.easeOut);
        // }
      });

      // socket.on("calling", (msg) {
      //   // ignore: avoid_print
      //   print("Nhận cuộc gọi: $msg");
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => VideoCallScreen(
      //         caller: sourceChat!.userName,
      //         creceiver: widget.chatModel.userName,
      //         callStatus: false,
      //       ),
      //     ),
      //   );
      // });
    });
  }

  Future<void> sendMessage(String type, String text) async {
    //database
    String id = await _chatMessagesViewModel.addChatMessage(
        sourceChat!.userName,
        widget.chatModel.userName,
        widget.chatModel.isGroup,
        type,
        text,
        DateTime.now(),
        reply != null ? reply!['id'] : "");
    // ignore: avoid_print
    print(id);

    //local

    setMessage(
        sourceChat!.userName,
        widget.chatModel.userName,
        widget.chatModel.isGroup,
        type,
        text,
        null,
        reply != null ? reply!['id'] ?? "" : "");

    //socket
    var data = {
      "author": sourceChat!.userName,
      "partition": widget.chatModel.userName,
      "isGroup": widget.chatModel.isGroup.toString(),
      "type": type,
      "text": text,
      'timestamp': DateTime.now().toString(),
      "reply": reply != null ? reply!['id'] : "",
    };
    socket.emit("message", data);

    setState(() {
      reply = null;
    });
  }

  Future<void> sendFile(String fileName, int size, String type) async {
    //database
    var data = {
      "author": sourceChat!.userName,
      "partition": widget.chatModel.userName,
      "isGroup": widget.chatModel.isGroup.toString(),
      "type": type,
      "text": fileName,
      "size": '$size',
      'timestamp': DateTime.now().toString(),
      "reply": reply != null ? reply!['id'] : "",
    };
    var responseSend = await networkHandler.post1("/chatmessage/add", data);
    // ignore: avoid_print
    print(responseSend);

    //local
    ChatMessagesModel messageModel = ChatMessagesModel(
      author: sourceChat!.userName,
      partition: widget.chatModel.userName,
      isGroup: widget.chatModel.isGroup,
      type: type,
      text: fileName,
      size: size,
      timestamp: DateTime.now(),
      reply: reply != null ? reply!['id'] : "",
      // DateTime.now().toString().substring(11, 16),
    );

    if (mounted) {
      setState(() {
        // messages.insert(0, messageModel);
        messages = [messageModel, ...messages];
      });
    }

    //socket
    socket.emit("message", data);

    setState(() {
      reply = null;
    });
  }

  void onImageSend(String path) async {
    for (var i = 0; i < popTime; i++) {
      Navigator.pop(context);
    }
    setState(() {
      popTime = 0;
    });

    try {
      setMessage(
          sourceChat!.userName,
          widget.chatModel.userName,
          widget.chatModel.isGroup,
          "image",
          path,
          null,
          reply != null ? reply!['id'] ?? "" : "");

      //add Image
      var request =
          http.MultipartRequest("POST", Uri.parse("$_url/image/addimage"));
      request.files.add(await http.MultipartFile.fromPath("img", path));
      request.headers.addAll({
        "Content-type": "multipart/form-data",
      });
      http.StreamedResponse response = await request.send();
      var httpResponse = await http.Response.fromStream(response);
      var data = json.decode(httpResponse.body);
      // print(data['path']);

      //send DB
      Map<String, String> dataMap = {
        "author": sourceChat!.userName,
        "partition": widget.chatModel.userName,
        "isGroup": widget.chatModel.isGroup.toString(),
        "type": "image",
        "text": data['path'],
        'timestamp': DateTime.now().toString(),
        "reply": reply != null ? reply!['id'] ?? "" : "",
      };
      await networkHandler.post("/chatmessage/add", dataMap);
      // print(responseSend);

      //send Socket
      socket.emit("message", {
        "sourceId": sourceChat!.userName,
        "targetId": widget.chatModel.userName,
        "type": "image",
        "text": data['path'],
        "reply": reply != null ? reply!['id'] ?? "" : "",
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void setMessage(String author, String partition, bool? isGroup, String type,
      String text, int? size, String reply) {
    ChatMessagesModel messageModel = ChatMessagesModel(
      author: author,
      partition: partition,
      isGroup: isGroup,
      type: type,
      text: text,
      size: size,
      timestamp: DateTime.now(),
      reply: reply,
    );

    if (mounted) {
      setState(() {
        messages = [messageModel, ...messages];
      });
    }
  }

  Future<void> setRelationship(String userRela, String chatterRela) async {
    var responseCheck = await networkHandler
        .get("/user/checkrelationship/${widget.chatModel.userName}");
    // print(responseCheck['status']);
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
      // ignore: avoid_print
      print(response);
      var response1 =
          await networkHandler.post1("/user/add/relationship", body1);
      // ignore: avoid_print
      print(response1);
    } else {
      var response =
          await networkHandler.post1("/user/update/relationship", body);
      // ignore: avoid_print
      print(response);
      var response1 =
          await networkHandler.post1("/user/update/relationship", body1);
      // ignore: avoid_print
      print(response1);
    }
  }

  Widget ketBan() {
    return InkWell(
      onTap: () async {
        if (relationship == "Kết bạn") {
          setRelationship("Đã gửi lời mời kết bạn", "Chấp nhận");
          setState(() {
            relationship = "Đã gửi lời mời kết bạn";
          });
        } else {
          if (relationship == "Chấp nhận") {
            setRelationship("Bạn bè", "Bạn bè");
            setState(() {
              relationship = "Bạn bè";
            });
          } else {
            if (relationship == "Đã gửi lời mời kết bạn") {
              setRelationship("Người lạ", "Người lạ");
              setState(() {
                relationship = "Kết bạn";
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
            const Icon(
              Icons.person_add_alt_outlined,
              color: Colors.grey,
            ),
            const SizedBox(width: 5),
            Text(
              relationship == "Người lạ" ? "Kết bạn" : relationship,
              style: const TextStyle(
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
                  iconcreation(
                    Icons.insert_drive_file,
                    Colors.indigo,
                    'Document',
                    () async {
                      result = await FilePicker.platform.pickFiles(
                        allowMultiple: true,
                        type: FileType.custom,
                        allowedExtensions: [
                          'docx',
                          'pdf',
                          'doc',
                          'jar',
                          'ppt',
                          'pttx',
                          'xls',
                          'xlss',
                          'txt',
                          'zip',
                          'rar'
                        ],
                      );
                      if (result != null) {
                        files =
                            result!.paths.map((path) => File(path!)).toList();
                        PlatformFile file1 = result!.files.first;
                        // PlatformFile file1 = result!.files.elementAt(0);
                        // File file2 = result!.files[0] as File;
                        String fileName =
                            await FileViewModel().uploadFile(file1.path!);
                        sendFile(fileName, file1.size, 'file');
                      } else {
                        // User canceled the picker
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                  ),
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
                  iconcreation(Icons.headset, Colors.orange, 'Audio', () async {
                    var result = await FilePicker.platform
                        .pickFiles(type: FileType.audio);
                    if (result != null) {
                      PlatformFile file = result.files.first;
                      String fileName =
                          await AudioViewModel().uploadAudio(file.path!);
                      sendFile(fileName, file.size, 'audio');
                    } else {
                      // User canceled the picker
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }),
                  const SizedBox(width: 40),
                  iconcreation(Icons.location_pin, Colors.teal, 'Location', () {
                    Navigator.pop(context);
                    _navigateMapAndChoose();
                  }),
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

  Future<void> _navigateMapAndChoose() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationShareMap()),
    );
    // ignore: avoid_print
    print("result: $result");
    sendMessage(
      "location",
      result,
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
            buttonMode: ButtonMode.MATERIAL,
          ),
        ),
      ),
    );
  }
}
