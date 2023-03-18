// ignore_for_file: file_names

import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/Model/Model/ChatMessagesModel.dart';

class ChatMessagesViewModel {
  NetworkHandler networkHandler = NetworkHandler();

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
