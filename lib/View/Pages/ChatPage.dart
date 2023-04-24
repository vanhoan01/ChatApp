// ignore_for_file: file_names

import 'package:chatapp/Model/List/ListChatModel.dart';
import 'package:chatapp/Model/List/ListChatterModel.dart';
import 'package:chatapp/Model/List/ListConversationModel.dart';
import 'package:chatapp/Model/Model/ChatModel.dart';
import 'package:chatapp/Model/Model/userModel.dart';
import 'package:chatapp/View/CustomUI/CustomCard.dart';
import 'package:chatapp/View/Pages/MenuScreen.dart';
import 'package:chatapp/View/Screens/CreateGroup.dart';
import 'package:chatapp/View/Screens/LoginScreen.dart';
import 'package:chatapp/View/Screens/SearchScreen.dart';
import 'package:chatapp/View/Screens/SelectContact.dart';
import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/View/Screens/UploadImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  NetworkHandler networkHandler = NetworkHandler();
  ListChatModel listChatModel = ListChatModel();
  ListChatterModel listChatterModel = ListChatterModel();
  ListConversationModel listConversationModel = ListConversationModel();
  late ChatModel sourceChat;
  late final String url;
  List<ChatModel> chatmodels = [];
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var responseChatters = await networkHandler.get("/user/get/chatters");
    List<ChatModel> chatModelChatter = [];
    if (true) {
      var listChatterModel = ListChatterModel.fromJson(responseChatters);
      var listChatters = listChatterModel.data;
      ChatModel chatModel;

      for (var i = 0; i < listChatters!.length; i = i + 1) {
        var last = await networkHandler.get(
            "/chatmessage/get/lastmesage/${listChatters.elementAt(i).userName}");
        String timestamp = "";
        String currentMessage = "";
        if (last != null) {
          timestamp = last['timestamp'];
          currentMessage =
              last['type'] == "image" ? "Đã gửi một hình ảnh" : last['text'];
        }
        // ignore: avoid_print
        print(listChatters.elementAt(i).userName);
        chatModel = ChatModel(
            userName: listChatters.elementAt(i).userName,
            displayName: listChatters.elementAt(i).displayName,
            avatarImage: listChatters.elementAt(i).avatarImage.toString(),
            isGroup: false,
            timestamp: timestamp,
            currentMessage: currentMessage);
        chatModelChatter.add(chatModel);
      }
    }
    // ignore: avoid_print
    print(chatModelChatter);
    var responseConversations =
        await networkHandler.get("/user/get/conversations");
    List<ChatModel> chatModelConversation = [];
    if (true) {
      var listConversationModel =
          ListConversationModel.fromJson(responseConversations);
      var listConversations = listConversationModel.data;
      ChatModel chatModel;
      for (var i = 0; i < listConversations!.length; i = i + 1) {
        var last = await networkHandler.get(
            "/chatmessage/get/lastmesagegroup/${listConversations.elementAt(i).id}");
        String timestamp = "";
        String currentMessage = "";
        if (last != null) {
          timestamp = last['timestamp'];
          currentMessage = last['type'] == "image" ? "Hình ảnh" : last['text'];
        }
        chatModel = ChatModel(
            userName: listConversations.elementAt(i).id,
            displayName: listConversations.elementAt(i).displayName,
            avatarImage: listConversations.elementAt(i).avatarImage,
            isGroup: true,
            timestamp: timestamp,
            currentMessage: currentMessage);
        chatModelConversation.add(chatModel);
      }
    }
    List<ChatModel> chatModelChatterConversation = [];
    chatModelChatterConversation = chatModelChatter;
    chatModelChatterConversation.addAll(chatModelConversation);
    // ignore: avoid_print
    print(chatModelChatterConversation);
    chatModelChatterConversation
        .sort((a, b) => b.timestamp.compareTo(a.timestamp));

    var responseUser = await networkHandler.get("/user/getData");
    UserModel userModel = UserModel.fromJson(responseUser);
    // ignore: avoid_print
    print(userModel);
    setState(() {
      chatmodels = chatModelChatterConversation;
      sourceChat = ChatModel(
          userName: userModel.userName,
          displayName: userModel.displayName,
          avatarImage:
              userModel.avatarImage == null ? "" : userModel.avatarImage!,
          isGroup: false,
          timestamp: '',
          currentMessage: '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SkyChat'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchScreen(),
              );
            },
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton<String>(
            offset: const Offset(-20, 45),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            onSelected: (value) {
              if (value == "dangxuat") {
                logout();
              }
              if (value == "New group") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const CreateGroup()));
              }
              if (value == "Settings") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const MenuScreen()));
              }
              if (value == "uploadimage") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const UploadImage()));
              }
              // ignore: avoid_print
              print(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'New group',
                  child: Text('Tạo nhóm mới'),
                ),
                const PopupMenuItem(
                  value: 'Starred messages',
                  child: Text('Tin nhắn quan trọng'),
                ),
                const PopupMenuItem(
                  value: 'Settings',
                  child: Text('Cài đặt'),
                ),
                const PopupMenuItem(
                  value: 'dangxuat',
                  child: Text('Đăng xuất'),
                ),
                const PopupMenuItem(
                  value: 'uploadimage',
                  child: Text('Upload image'),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => const SelectContact()));
        },
        child: const Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      body: chatmodels.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) =>
                  CustomCard(chatModel: chatmodels[index]),
              itemCount: chatmodels.length,
            )
          : invite_friends(),
    );
  }

  void logout() async {
    await storage.delete(key: "token");
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }

  // ignore: non_constant_identifier_names
  Widget invite_friends() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
      child: Column(
        children: [
          const Text("Mời bạn bè"),
          // ignore: prefer_const_constructors
          Text(
            "Hiện tại bạn không có bạn bè nào. Hãy dùng nút bên dưới để mời họ sử dụng",
            textAlign: TextAlign.center,
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.blue.withOpacity(0.04);
                  }
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed)) {
                    return Colors.blue.withOpacity(0.12);
                  }
                  return null; // Defer to the widget's default.
                },
              ),
            ),
            onPressed: () {},
            child: const Text('Mời bạn bè'),
          ),
          const Text(
            "Trò chuyện với bạn bè của bạn sử dụng ChatApp",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
