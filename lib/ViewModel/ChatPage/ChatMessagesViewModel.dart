// ignore_for_file: file_names

import 'dart:convert';

import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/Model/List/ListCallModel.dart';
import 'package:chatapp/Model/List/ListChatMessagesModel.dart';
import 'package:chatapp/Model/Model/CallModel.dart';
import 'package:chatapp/Model/Model/ChatMessagesModel.dart';
import 'package:chatapp/Model/Model/ChatterModel.dart';
import 'package:chatapp/Model/Model/userModel.dart';
import 'package:chatapp/ViewModel/ChatterViewModel.dart';
import 'package:chatapp/ViewModel/UserViewModel.dart';

class ChatMessagesViewModel {
  NetworkHandler networkHandler = NetworkHandler();

  Future<String> addChatMessage(String author, String partition, bool isGroup,
      String type, String text, DateTime timestamp, String? reply) async {
    String id = "";
    var body = {
      "author": author,
      "partition": partition,
      "isGroup": isGroup.toString(),
      "type": type,
      "text": text,
      'timestamp': timestamp.toString(),
      "reply": reply ?? "",
    };

    try {
      var response = await networkHandler.post1("/chatmessage/add", body);
      id = json.decode(response.body)['data'];
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return id;
  }

  Future<void> updateCallEnd(String id, int size) async {
    var body = {"id": id, "size": size};

    try {
      await networkHandler.post1("/chatmessage/updatecallend", body);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<ChatMessagesModel> getMessageByID(String id) async {
    ChatMessagesModel? chatMessagesModel;
    try {
      var resMessage =
          await networkHandler.get("/chatmessage/get/messageid/$id");
      chatMessagesModel = ChatMessagesModel.fromJson(resMessage);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return chatMessagesModel!;
  }

  Future<List<ChatMessagesModel>?> getMessagesGroup(String partition) async {
    Map<String, String> body = {"partition": partition};
    List<ChatMessagesModel>? listChatMessages = [];
    try {
      var responseChatMessage =
          await networkHandler.getpost("/chatmessage/get/messagesgroup", body);
      ListChatMessagesModel listChatMessagesModel =
          ListChatMessagesModel.fromJson(responseChatMessage);
      listChatMessages = listChatMessagesModel.data;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return listChatMessages!;
  }

  Future<List<ChatMessagesModel>?> getMessages(String partition) async {
    Map<String, String> body = {"partition": partition};
    List<ChatMessagesModel>? listChatMessages = [];
    try {
      var responseChatMessage =
          await networkHandler.getpost("/chatmessage/get/messages", body);
      ListChatMessagesModel listChatMessagesModel =
          ListChatMessagesModel.fromJson(responseChatMessage);
      listChatMessages = listChatMessagesModel.data;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return listChatMessages!;
  }

  Future<List<ChatMessagesModel>> getPhotos() async {
    List<ChatMessagesModel>? listChatMessagesModel = [];
    try {
      var resMessage = await networkHandler.get("/chatmessage/get/photos");
      listChatMessagesModel = ListChatMessagesModel.fromJson(resMessage).data;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return listChatMessagesModel!;
  }

  Future<List<CallModel>> getCalls() async {
    List<CallModel>? listCallModel = [];
    try {
      var resMessage = await networkHandler.get("/chatmessage/get/calls");
      List<ChatMessagesModel>? listChatMessagesModel =
          ListChatMessagesModel.fromJson(resMessage).data;
      for (var chatMessages in listChatMessagesModel!) {
        ChatterModel chatterModel = await ChatterViewModel()
            .getChatterModel(chatMessages.partition ?? "");
        listCallModel.add(CallModel(
            displayName: chatterModel.displayName,
            avatarImage: chatterModel.avatarImage ?? "",
            timestamp: chatMessages.timestamp,
            type: chatMessages.type,
            text: chatMessages.text,
            isGroup: chatMessages.isGroup ?? false,
            precense: chatterModel.precense ?? "Không hoạt động"));
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return listCallModel;
  }

  Future<List<ChatMessagesModel>> getFiles() async {
    List<ChatMessagesModel>? listChatMessagesModel = [];
    try {
      var resMessage = await networkHandler.get("/chatmessage/get/files");
      listChatMessagesModel = ListChatMessagesModel.fromJson(resMessage).data;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return listChatMessagesModel!;
  }

  Future<List<ChatMessagesModel>> getProfileReacts() async {
    List<ChatMessagesModel>? listChatMessagesModel = [];
    try {
      var resMessage =
          await networkHandler.get("/chatmessage/get/profilereacts");

      listChatMessagesModel = ListChatMessagesModel.fromJson(resMessage).data;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return listChatMessagesModel!;
  }

  Future<List<ChatMessagesModel>> getSaveds() async {
    List<ChatMessagesModel>? listChatMessagesModel = [];
    try {
      var resMessage = await networkHandler.get("/chatmessage/get/saveds");

      listChatMessagesModel = ListChatMessagesModel.fromJson(resMessage).data;
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return listChatMessagesModel!;
  }

  Future<void> addReacts(String id, String userId, String react) async {
    var body = {
      "id": id,
      "react": {"userId": userId, "react": react}
    };

    try {
      await networkHandler.post1("/chatmessage/add/reacts", body);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> deleteReacts(String id, String userId) async {
    var body = {"id": id, "userId": userId};

    try {
      await networkHandler.post1("/chatmessage/delete/reacts", body);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> deleteChatmessage(String id) async {
    try {
      await networkHandler.delete("/chatmessage/delete/$id");
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> updateReacts(String id, String userId, String react) async {
    var body = {"id": id, "userId": userId, "react": react};

    try {
      await networkHandler.post1("/chatmessage/update/reacts", body);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
