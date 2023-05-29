// ignore_for_file: file_names

import 'dart:isolate';
import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:chatapp/Model/Model/ChatMessagesModel.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/View/Screens/Image/ImageProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class PageViewImages extends StatefulWidget {
  const PageViewImages(
      {super.key, required this.chatMessagesList, required this.position});
  final List<ChatMessagesModel> chatMessagesList;
  final int position;

  @override
  State<PageViewImages> createState() => _PageViewImagesState();
}

class _PageViewImagesState extends State<PageViewImages> {
  late PageController _controller;
  int imageindex = 0;
  final ReceivePort _port = ReceivePort();
  late bool _saveInPublicStorage;

  @override
  void dispose() {
    _controller.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  void initState() {
    // downloadInit();
    super.initState();
    setState(() {
      imageindex = widget.position;
    });

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback, step: 1);

    _saveInPublicStorage = false;
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    // _port.listen((dynamic data) {
    //   print("Callback on UI isolate:");
    // });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    print(
      'Callback on background isolate: '
      'task ($id) is in status ($status) and process ($progress)',
    );

    IsolateNameServer.lookupPortByName('downloader_send_port')
        ?.send([id, status, progress]);
  }

  Future<String> _findLocalPath() async {
    String externalStorageDirPath = "";
    try {
      externalStorageDirPath = await AndroidPathProvider.downloadsPath;
    } catch (e) {
      final directory = await getExternalStorageDirectory();
      externalStorageDirPath = directory?.path ?? "";
    }
    return externalStorageDirPath;
  }

  @override
  Widget build(BuildContext context) {
    _controller = PageController(initialPage: widget.position);
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.chatMessagesList.length,
            itemBuilder: (BuildContext context, int index) {
              return ImageProfileScreen(
                path: AppUrl.imageUrl + widget.chatMessagesList[index].text,
                type: widget.chatMessagesList[index].type,
              );
            },
            onPageChanged: (value) {
              setState(() {
                imageindex = value;
              });
            },
          ),
          Positioned(
            top: 30,
            left: 5,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 5,
            child: IconButton(
              icon: const Icon(
                Icons.file_download_outlined,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () async {
                try {
                  final taskId = await FlutterDownloader.enqueue(
                    url:
                        "${AppUrl.imageUrl}${widget.chatMessagesList[imageindex].text}",
                    headers: {"auth": "test_for_sql_encoding"},
                    savedDir: await _findLocalPath(),
                    showNotification: false,
                    openFileFromNotification: false,
                    saveInPublicStorage: true,
                  );
                  if (taskId != null) {
                    showSnack('Ảnh đã được lưu vào thiết bị này!');
                  } else {
                    showSnack('Kiểm tra mạng của thiết bị!');
                  }
                } catch (e) {
                  // ignore: avoid_print
                  print(e);
                  showSnack('Kiểm tra mạng của thiết bị!');
                }
              },
            ),
          ),
          Positioned(
            bottom: 30,
            right: 5,
            child: IconButton(
              icon: const Icon(
                Icons.share,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () => print(imageindex),
            ),
          ),
        ],
      ),
    );
  }

  void showSnack(String title) {
    final snackbar = SnackBar(
        backgroundColor: Colors.grey,
        content: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,
          ),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
