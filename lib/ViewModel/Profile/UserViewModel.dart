// ignore_for_file: file_names

import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/Model/Model/userModel.dart';
import 'package:chatapp/ViewModel/Image/ImageViewModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

class UserViewModel {
  NetworkHandler networkHandler = NetworkHandler();
  final storage = const FlutterSecureStorage();

  Future<UserModel> getFriendStatus() async {
    UserModel? userModel;
    try {
      var responsePD = await networkHandler.get("/user/getData");
      userModel = UserModel.fromJson(responsePD);
      // ignore: avoid_print
      print('userModel: ${userModel.displayName}');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return userModel!;
  }

  Future<void> updateDisplayName(String displayName) async {
    try {
      var responseUD =
          await networkHandler.get("/user/update/diplayname/$displayName");
      // ignore: avoid_print
      print('responsePD: $responseUD');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> updateAvatarImage(PickedFile imageFile) async {
    try {
      String avatarImage = await ImageViewModel(imageFile).uploadImage();
      var responseUD =
          await networkHandler.get("/user/update/avatarimage/$avatarImage");
      // ignore: avoid_print
      print('responsePD: $responseUD');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> updateChatID(String chatID) async {
    try {
      var responseUD = await networkHandler.get("/user/update/chatid/$chatID");
      // ignore: avoid_print
      print('token: $responseUD["token"]');
      await storage.write(key: "token", value: responseUD["token"]);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> updateBiography(String biography) async {
    try {
      var responseUD =
          await networkHandler.get("/user/update/biography/$biography");
      // ignore: avoid_print
      print('responsePD: $responseUD');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> updateLink(String link) async {
    try {
      var responseUD = await networkHandler.get("/user/update/link/$link");
      // ignore: avoid_print
      print('responsePD: $responseUD');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<String> getAvartar(String userName) async {
    String avt = "";
    try {
      var responseAvartar =
          await networkHandler.get("/user/get/image/$userName");
      // ignore: avoid_print
      print('responsePD: $responseAvartar');
      avt = responseAvartar.toString();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return avt;
  }
}
