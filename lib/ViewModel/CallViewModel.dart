// ignore_for_file: file_names

import 'dart:convert';

import 'package:chatapp/Data/Services/network_handler.dart';

class CallViewModel {
  NetworkHandler networkHandler = NetworkHandler();

  Future<String> gertctoken(bool isPublisher, String channel) async {
    String token = "";
    var body = {
      "isPublisher": isPublisher,
      "channel": channel,
    };
    try {
      var responsePD = await networkHandler.post1("/call/rtctoken", body);
      var result = json.decode(responsePD.body);
      // ignore: avoid_print
      token = result['token'];
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    print('token result:  $token');
    return token;
  }
}
