// ignore_for_file: file_names

import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/Model/Model/ChatterModel.dart';
import 'package:chatapp/Model/Model/ConversationModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class ConversationViewModel {
  NetworkHandler networkHandler = NetworkHandler();
  final storage = const FlutterSecureStorage();

  Future<ConversationModel> getConversationViewModel(String id) async {
    ConversationModel? conversationModel;
    try {
      var responsePD = await networkHandler.get("/conversation/get/group/$id");
      conversationModel = ConversationModel.fromJson(responsePD);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return conversationModel!;
  }

  Future<Response> leaveGroup(String id) async {
    var body = {"id": id};
    var response =
        await networkHandler.post1("/conversation/delete/member", body);
    return response;
  }

  Future<Response> addMembers(
      String id, List<Map<String, String>> members) async {
    var body = {
      "id": id,
      "members": members,
    };
    var response = await networkHandler.post1("/conversation/add/member", body);
    return response;
  }
}
