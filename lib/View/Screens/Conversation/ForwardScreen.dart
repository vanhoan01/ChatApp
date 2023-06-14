// ignore_for_file: file_names

import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/Model/List/ListChatterModel.dart';
import 'package:chatapp/Model/Model/ChatMessagesModel.dart';
import 'package:chatapp/Model/Model/ChatModel.dart';
import 'package:chatapp/Model/Model/SearchModel.dart';
import 'package:chatapp/View/Components/Conversation/ForwardItem.dart';
import 'package:chatapp/View/Components/CustomUI/SearchItem.dart';
import 'package:chatapp/ViewModel/UserViewModel.dart';
import 'package:flutter/material.dart';

enum _SearchBody {
  suggestions,
  results,
  goiy,
}

class ForwardScreen<T> extends StatefulWidget {
  const ForwardScreen({super.key, required this.userId, required this.chatMM});
  final String userId;
  final ChatMessagesModel chatMM;
  @override
  State<StatefulWidget> createState() => ForwardScreenState<T>();
}

class ForwardScreenState<T> extends State<ForwardScreen<T>> {
  FocusNode focusNode = FocusNode();
  final TextEditingController _queryTextController = TextEditingController();
  final ValueNotifier<_SearchBody?> _currentBodyNotifier =
      ValueNotifier<_SearchBody?>(null);
  FocusNode? _focusNode;
  _SearchBody? get _currentBody => _currentBodyNotifier.value;
  set _currentBody(_SearchBody? value) {
    _currentBodyNotifier.value = value;
  }

  InputDecorationTheme? searchFieldDecorationTheme;
  TextStyle? searchFieldStyle;
  final String _searchFieldLabel = "Tìm kiếm";
  NetworkHandler networkHandler = NetworkHandler();
  List<ChatModel> chatmodels = [];
  String query = '';
  TextInputAction? textInputAction;
  TextInputType? keyboardType;
  UserViewModel userViewModel = UserViewModel();
  List<SearchModel>? searchModelGoiY;

  @override
  void initState() {
    super.initState();
    _queryTextController.addListener(_onQueryChanged);

    _currentBodyNotifier.addListener(_onSearchBodyChanged);
    focusNode.addListener(_onFocusChanged);
    _focusNode = focusNode;
    _currentBody = _SearchBody.goiy;
  }

  @override
  void dispose() {
    super.dispose();
    _queryTextController.removeListener(_onQueryChanged);
    _currentBodyNotifier.removeListener(_onSearchBodyChanged);
    _focusNode = null;
    focusNode.dispose();
  }

  void showSuggestions(BuildContext context) {
    assert(_focusNode != null,
        '_focusNode must be set by route before showSuggestions is called.');
    _focusNode!.requestFocus();
    _currentBody = _SearchBody.suggestions;
  }

  void _onFocusChanged() {
    if (focusNode.hasFocus && _currentBody != _SearchBody.suggestions) {
      showSuggestions(context);
    }
  }

  void _onQueryChanged() {
    setState(() {
      query = _queryTextController.text;
    });
  }

  void _onSearchBodyChanged() {
    setState(() {
      // rebuild ourselves because search body changed.
    });
  }

  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  void close(BuildContext context, T? result) {
    _currentBody = null;
    _focusNode?.unfocus();
    Navigator.of(context).pop(result);
  }

  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    assert(theme != null);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
          // ignore: deprecated_member_use
          brightness: colorScheme.brightness,
          backgroundColor: colorScheme.brightness == Brightness.dark
              ? Colors.grey[900]
              : Colors.white,
          iconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
          surfaceTintColor: Colors.black,
          toolbarTextStyle: theme.textTheme.bodyText2,
          titleTextStyle: theme.textTheme.headline6),
      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
            border: InputBorder.none,
          ),
    );
  }

  Widget buildGoiY(BuildContext context) {
    fetchData2();
    return ListView.builder(
      itemCount: searchModelGoiY == null ? 0 : searchModelGoiY!.length,
      itemBuilder: (context, index) {
        SearchModel searchModel = searchModelGoiY![index];
        // return Container();
        return ForwardItem(
          chatModel: searchModel,
          chatMMId: widget.chatMM.id ?? "",
          userName: widget.userId,
        );
      },
    );
  }

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
        return Container();
        // return ForwardItem(
        //   chatModel: chatModel,
        //   chatMMId: widget.chatMM.id ?? "",
        //   userName: widget.userId,
        // );
      },
    );
  }

  Future fetchData2() async {
    List<SearchModel>? searchModelList =
        await userViewModel.getSuggestionsSearch();
    setState(() {
      searchModelGoiY = searchModelList;
    });
  }

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
        return Container();
        // return ForwardItem(
        //   chatModel: chatModel,
        //   chatMMId: widget.chatMM.id ?? "",
        //   userName: widget.userId,
        // );
      },
    );
  }

  void showResults(BuildContext context) {
    _focusNode?.unfocus();
    _currentBody = _SearchBody.results;
  }

  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          _queryTextController.text = "";
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  PreferredSizeWidget? buildBottom(BuildContext context) => null;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = appBarTheme(context);
    Widget? body;
    switch (_currentBody) {
      case _SearchBody.suggestions:
        body = KeyedSubtree(
          key: const ValueKey<_SearchBody>(_SearchBody.suggestions),
          child: buildSuggestions(context),
        );
        break;
      case _SearchBody.results:
        body = KeyedSubtree(
          key: const ValueKey<_SearchBody>(_SearchBody.results),
          child: buildResults(context),
        );
        break;
      case _SearchBody.goiy:
        body = KeyedSubtree(
          key: const ValueKey<_SearchBody>(_SearchBody.results),
          child: buildGoiY(context),
        );
        break;
      case null:
        break;
    }

    late final String routeName;
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        routeName = '';
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        routeName = _searchFieldLabel;
    }

    return Semantics(
      explicitChildNodes: true,
      scopesRoute: true,
      namesRoute: true,
      label: routeName,
      child: Theme(
        data: theme,
        child: Scaffold(
          appBar: AppBar(
            leading: buildLeading(context),
            title: TextField(
              controller: _queryTextController,
              focusNode: focusNode,
              cursorColor: Colors.black,
              style: searchFieldStyle ?? theme.textTheme.headline6,
              textInputAction: textInputAction,
              keyboardType: keyboardType,
              onSubmitted: (String _) {
                showResults(context);
              },
              decoration: InputDecoration(hintText: _searchFieldLabel),
            ),
            actions: buildActions(context),
            bottom: buildBottom(context),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: body,
          ),
        ),
      ),
    );
  }
}
