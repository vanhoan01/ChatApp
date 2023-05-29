// ignore_for_file: file_names

import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/Model/Model/userModel.dart';
import 'package:chatapp/ViewModel/Image/ImageViewModel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class UserViewModel {
  NetworkHandler networkHandler = NetworkHandler();
  final storage = const FlutterSecureStorage();

  Future<UserModel> getUserModel() async {
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

  Future<bool> checkPhoneNumber(String phoneNumber) async {
    try {
      var body = await networkHandler
          .getNoToken("/user/checkphonenumber/$phoneNumber");
      // ignore: avoid_print
      print('responsePD: $body');
      bool check = body['status'];
      return check;
    } catch (e) {
      return true;
    }
  }

  Future<bool> checkUserName(String userName) async {
    try {
      var body =
          await networkHandler.getNoToken("/user/checkusername/$userName");
      // ignore: avoid_print
      print('responsePD: $body');
      bool check = body['status'];
      return check;
    } catch (e) {
      return true;
    }
  }

  Future<Response> register(String userName, String password,
      String displayName, String phoneNumber, String avatarImage) async {
    Map<String, String> data = {
      "userName": userName,
      "password": password,
      "displayName": displayName,
      "phoneNumber": phoneNumber,
      "avatarImage": avatarImage,
    };
    var body = await networkHandler.post2("/user/register", data);
    return body;
  }

  Future<Response> login(String userName, String password) async {
    Map<String, String> data = {
      "userName": userName,
      "password": password,
    };
    var body = await networkHandler.post2("/user/login", data);
    return body;
  }

  Future<String> getRelationship(String userName) async {
    String? relation;
    try {
      var res = await networkHandler.get("/user/get/relationship/$userName");
      relation = res.toString();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return relation!;
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

  Future<void> addSaved(String idmes) async {
    try {
      var responseUD = await networkHandler.get("/user/saved/add/$idmes");
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
