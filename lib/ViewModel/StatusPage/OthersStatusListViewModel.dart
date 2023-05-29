// ignore_for_file: file_names

import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/Model/List/ListOthersStatus.dart';
import 'package:chatapp/Model/Model/OthersStatusModel.dart';

class OthersStatusListViewModel {
  NetworkHandler networkHandler = NetworkHandler();

  Future<List<OthersStatusModel>> getFriendStatus() async {
    List<OthersStatusModel> data = [];
    try {
      var responsePD = await networkHandler.get("/user/get/friends");
      // print('responsePD[data]: ${responsePD['data']}');
      ListOthersStatus listOthersStatus = ListOthersStatus.fromJson(responsePD);
      // print('listOthersStatus: ${listOthersStatus.data![0].displayName}');
      data = listOthersStatus.data!;
    } catch (e) {
      print(e);
    }
    return data;
  }

  Future<List<OthersStatusModel>> getFriendRequests() async {
    List<OthersStatusModel> data = [];
    try {
      var responsePD = await networkHandler.get("/user/get/friendrequests");
      // print('responsePD[data]: ${responsePD['data']}');
      ListOthersStatus listOthersStatus = ListOthersStatus.fromJson(responsePD);
      // print('listOthersStatus: ${listOthersStatus.data![0].displayName}');
      data = listOthersStatus.data!;
    } catch (e) {
      print(e);
    }
    return data;
  }

  Future<List<OthersStatusModel>> getGroupStatus() async {
    List<OthersStatusModel> data = [];
    try {
      var responsePD = await networkHandler.get("/user/get/conversations");
      // print('responsePD[data]: ${responsePD['data']}');
      ListOthersStatus listOthersStatus = ListOthersStatus.fromJson(responsePD);
      // print('listOthersStatus: ${listOthersStatus.data![0].displayName}');
      data = listOthersStatus.data!;
    } catch (e) {
      print(e);
    }
    return data;
  }
}
