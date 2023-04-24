// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FileViewModel {
  NetworkHandler networkHandler = NetworkHandler();

  Future<String> uploadFile(String path) async {
    String fileName = "";
    var request = http.MultipartRequest(
        "POST", Uri.parse("${AppUrl.baseUrl}/file/uploadfile/"));
    request.files.add(await http.MultipartFile.fromPath("myfile", path));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
    });
    http.StreamedResponse response = await request.send();
    var httpResponse = await http.Response.fromStream(response);
    var data = json.decode(httpResponse.body);
    print("data: $data");
    fileName = data['path'];
    print("fileName: $fileName");
    return fileName;
  }

  Future<int> getSize(String fileName) async {
    int size = 0;
    try {
      var responseData = await networkHandler.get("/uploads/files/$fileName");
      var uint8list = responseData.bodyBytes;
      var buffer = uint8list.buffer;
      ByteData byteData = ByteData.view(buffer);
      var tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/img').writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      size = file.lengthSync();
      print('size: $size');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return size;
  }
}
