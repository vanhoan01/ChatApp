import 'package:chatapp/Model/Model/ChatModel.dart';
import 'package:chatapp/View/CustomUI/SearchItem.dart';
import 'package:flutter/material.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({Key? key, required this.searchkey}) : super(key: key);
  final String searchkey;

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  late List<ChatModel> chatmodels = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    ChatModel chatModel;
    List<ChatModel> chatModelChatter = [];
    for (var i = 0; i < 10; i = i + 1) {
      chatModel = ChatModel(
          userName: "hoan$i",
          displayName: "Văn Hoàn $i",
          avatarImage: "",
          isGroup: false,
          timestamp: '03:00',
          currentMessage: 'currentMessage');
      chatModelChatter.add(chatModel);
    }
    setState(() {
      chatmodels = chatModelChatter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) =>
            SearchItem(chatModel: chatmodels[index]),
        itemCount: chatmodels.length,
      ),
    );
  }
}
