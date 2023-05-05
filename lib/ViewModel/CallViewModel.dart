// ignore_for_file: file_names

import 'dart:convert';

import 'package:chatapp/Data/Services/network_handler.dart';

class CallViewModel {
  NetworkHandler networkHandler = NetworkHandler();

  Future<String> gertctoken(String channelName, String account) async {
    String token = "";
    var body = {
      "channelName": channelName,
      "account": account,
    };
    try {
      var responsePD = await networkHandler.post1("/call/rtctoken", body);
      token = json.decode(responsePD.body);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    print('token result:  $token');
    return token;
  }
}
