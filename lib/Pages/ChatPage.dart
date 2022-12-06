import 'package:chatapp/CustomUI/CustomCard.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Model/ListChatModel.dart';
import 'package:chatapp/Model/ListChatterModel.dart';
import 'package:chatapp/Model/ListConversationModel.dart';
import 'package:chatapp/Screens/SelectContact.dart';
import 'package:chatapp/Services/metwork_handler.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
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
  List<ChatModel> chatmodels = [
    // ChatModel(
    //   id: 1,
    //   name: 'Dev Stack',
    //   isGroup: false,
    //   currentMessage: 'Hi everyone',
    //   time: '01:00',
    //   icon: 'person.svg',
    // ),
    // ChatModel(
    //   id: 2,
    //   name: 'Kishor',
    //   isGroup: false,
    //   currentMessage: 'Hi Kishor',
    //   time: '02:00',
    //   icon: 'person.svg',
    // ),
    // ChatModel(
    //   id: 3,
    //   name: 'Collins',
    //   isGroup: false,
    //   currentMessage: 'Hi Collins',
    //   time: '03:00',
    //   icon: 'person.svg',
    // ),
  ];
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
        chatModel = ChatModel(
            userName: listChatters.elementAt(i).userName,
            displayName: listChatters.elementAt(i).displayName,
            avatarImage: listChatters.elementAt(i).avatarImage.toString(),
            isGroup: false,
            timestamp: '03:00',
            currentMessage: 'currentMessage');
        chatModelChatter.add(chatModel);
      }
    }
    print(chatModelChatter);
    // Map<String, String> data = {};
    // listChatModel = ListChatModel.fromJson(responseChatters);
    var responseConversations =
        await networkHandler.get("/user/get/conversations");
    List<ChatModel> chatModelConversation = [];
    if (true) {
      var listConversationModel =
          ListConversationModel.fromJson(responseConversations);
      var listConversations = listConversationModel.data;
      ChatModel chatModel;
      for (var i = 0; i < listConversations!.length; i = i + 1) {
        chatModel = ChatModel(
            userName: listConversations.elementAt(i).id,
            displayName: listConversations.elementAt(i).displayName,
            avatarImage: '',
            isGroup: true,
            timestamp: '04:00',
            currentMessage: 'currentMessage');
        chatModelConversation.add(chatModel);
      }
    }
    List<ChatModel> chatModelChatterConversation = [];
    chatModelChatterConversation = chatModelChatter;
    chatModelChatterConversation.addAll(chatModelConversation);
    print(chatModelChatterConversation);
    chatModelChatterConversation
        .sort((a, b) => b.timestamp.compareTo(a.timestamp));
    setState(() {
      chatmodels = chatModelChatterConversation;
      sourceChat = ChatModel(
          userName: 'hoan',
          displayName: 'Văn Hoàn',
          avatarImage: '',
          isGroup: false,
          timestamp: '03:00',
          currentMessage: 'currentMessage');
    });
  }

  @override
  Widget build(BuildContext context) {
    // sourceChat = chatmodels.removeAt(0);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => SelectContact()));
        },
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      body: chatmodels.length > 0
          ? ListView.builder(
              itemBuilder: (context, index) => CustomCard(
                chatModel: chatmodels[index],
                sourchat: sourceChat,
              ),
              itemCount: chatmodels.length,
            )
          : invite_friends(),
    );
  }

  Widget invite_friends() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
      child: Column(
        children: [
          Text("Mời bạn bè"),
          Text(
              "Hiện tại bạn không có bạn bè nào. Hãy dùng nút bên dưới để mời họ sử dụng"),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered))
                    return Colors.blue.withOpacity(0.04);
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed))
                    return Colors.blue.withOpacity(0.12);
                  return null; // Defer to the widget's default.
                },
              ),
            ),
            onPressed: () {},
            child: Text('Mời bạn bè'),
          ),
          Text("Trò chuyện với bạn bè của bạn sử dụng WhatsApp"),
        ],
      ),
    );
  }
}
