// ignore_for_file: file_names

import 'dart:convert';
import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:http/http.dart' as http;

class FileViewModel {
  final String path;
  FileViewModel(this.path);
  NetworkHandler networkHandler = NetworkHandler();

  Future<String> uploadFile() async {
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
}
