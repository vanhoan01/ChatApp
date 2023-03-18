// ignore_for_file: file_names

import 'dart:convert';
import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageViewModel {
  final PickedFile imageFile;
  ImageViewModel(this.imageFile);
  NetworkHandler networkHandler = NetworkHandler();

  Future<String> uploadImage() async {
    String avatarImage = "";
    var request = http.MultipartRequest(
        "POST", Uri.parse("${AppUrl.baseUrl}/image/addimage"));
    request.files.add(await http.MultipartFile.fromPath("img", imageFile.path));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
    });
    http.StreamedResponse response = await request.send();
    var httpResponse = await http.Response.fromStream(response);
    var data = json.decode(httpResponse.body);
    print("data: $data");
    avatarImage = data['path'];
    print("avatarImage: $avatarImage");
    return avatarImage;
  }
}
