// ignore_for_file: file_names

import 'dart:convert';
import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class VideoViewModel {
  NetworkHandler networkHandler = NetworkHandler();

  Future<String> uploadVideo(String path) async {
    String videoName = "";
    var request = http.MultipartRequest(
        "POST", Uri.parse("${AppUrl.baseUrl}/video/addvideo"));
    request.files.add(await http.MultipartFile.fromPath("video", path));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
    });
    http.StreamedResponse response = await request.send();
    var httpResponse = await http.Response.fromStream(response);
    var data = json.decode(httpResponse.body);
    print("data: $data");
    videoName = data['path'].toString();
    print("videoName: $videoName");
    return videoName;
  }
}
