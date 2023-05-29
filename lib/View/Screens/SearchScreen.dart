// ignore_for_file: file_names

import 'package:chatapp/Model/List/ListChatterModel.dart';
import 'package:chatapp/Model/Model/ChatModel.dart';
import 'package:chatapp/View/Components/CustomUI/SearchItem.dart';
import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:flutter/material.dart';

class SearchScreen extends SearchDelegate {
  NetworkHandler networkHandler = NetworkHandler();
  List<ChatModel> chatmodels = [];

  Future fetchData(String query) async {
    var responseChatters = await networkHandler.get("/chatter/search/$query");
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
            timestamp: DateTime.now(),
            currentMessage: 'currentMessage');
        chatModelChatter.add(chatModel);
      }
    }
    // ignore: avoid_print
    print(chatModelChatter);
    // Map<String, String> data = {};
    // listChatModel = ListChatModel.fromJson(responseChatters);
    var responseConversations =
        await networkHandler.get("/user/get/conversations");
    List<ChatModel> chatModelConversation = [];
    // if (true) {
    //   var listConversationModel =
    //       ListConversationModel.fromJson(responseConversations);
    //   var listConversations = listConversationModel.data;
    //   ChatModel chatModel;
    //   for (var i = 0; i < listConversations!.length; i = i + 1) {
    //     chatModel = ChatModel(
    //         userName: listConversations.elementAt(i).id,
    //         displayName: listConversations.elementAt(i).displayName,
    //         avatarImage: '',
    //         isGroup: true,
    //         timestamp: '04:00',
    //         currentMessage: 'currentMessage');
    //     chatModelConversation.add(chatModel);
    //   }
    // }
    List<ChatModel> chatModelChatterConversation = [];
    chatModelChatterConversation = chatModelChatter;
    chatModelChatterConversation.addAll(chatModelConversation);
    // print(chatModelChatterConversation);
    // chatModelChatterConversation
    //     .sort((a, b) => b.timestamp.compareTo(a.timestamp));
    chatmodels = chatModelChatterConversation;
  }

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<ChatModel> matchQuery = [];
    if (query.trim().isNotEmpty) {
      fetchData(query.trim());
      matchQuery = chatmodels;
      print(matchQuery);
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        ChatModel chatModel = matchQuery[index];
        return SearchItem(chatModel: chatModel);
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<ChatModel> matchQuery = [];
    if (query.trim().isNotEmpty) {
      fetchData(query.trim());
      matchQuery = chatmodels;
      print(matchQuery);
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        ChatModel chatModel = matchQuery[index];
        return SearchItem(chatModel: chatModel);
      },
    );
    // return SearchResult(searchkey: query);
  }
}
