// ignore_for_file: file_names

import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/Model/Model/ChatterModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class ChatterViewModel {
  NetworkHandler networkHandler = NetworkHandler();
  final storage = const FlutterSecureStorage();

  Future<Response> register(String userName, String password,
      String displayName, String phoneNumber, String avatarImage) async {
    Map<String, String> data = {
      "userName": userName,
      "password": password,
      "displayName": displayName,
      "phoneNumber": phoneNumber,
      "avatarImage": avatarImage,
    };
    var body = await networkHandler.post2("/chatter/register", data);
    return body;
  }

  Future<ChatterModel> getChatterModel(String userName) async {
    ChatterModel? chatterModel;
    try {
      var responsePD =
          await networkHandler.get("/chatter/get/chatter/$userName");
      chatterModel = ChatterModel.fromJson(responsePD);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return chatterModel!;
  }
}
