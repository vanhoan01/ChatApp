import 'package:chatapp/CustomUI/ButtonCard.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Screens/Homescreen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late ChatModel sourceChat;
  List<ChatModel> chatmodels = [
    ChatModel(
      id: 1,
      name: 'Dev Stack',
      isGroup: false,
      currentMessage: 'Hi everyone',
      time: '01:00',
      icon: 'person.svg',
    ),
    ChatModel(
      id: 2,
      name: 'Kishor',
      isGroup: false,
      currentMessage: 'Hi Kishor',
      time: '02:00',
      icon: 'person.svg',
    ),
    ChatModel(
      id: 3,
      name: 'Collins',
      isGroup: false,
      currentMessage: 'Hi Collins',
      time: '03:00',
      icon: 'person.svg',
    ),
    // ChatModel(
    //     name: 'Butcher',
    //     isGroup: true,
    //     currentMessage: 'Hi Hi',
    //     time: '05:00',
    //     icon: 'groups.svg'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: chatmodels.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            sourceChat = chatmodels.removeAt(index);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (builder) => Homescreen(
                  chatmodels: chatmodels,
                  sourchat: sourceChat,
                ),
              ),
            );
          },
          child: ButtonCard(
            name: chatmodels[index].name,
            icon: Icons.person,
          ),
        ),
      ),
    );
  }
}
