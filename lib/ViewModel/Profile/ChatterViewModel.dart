// ignore_for_file: file_names

import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/Model/Model/ChatterModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatterViewModel {
  NetworkHandler networkHandler = NetworkHandler();
  final storage = const FlutterSecureStorage();

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
