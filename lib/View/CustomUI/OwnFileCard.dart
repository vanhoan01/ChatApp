import 'dart:io';
import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/ViewModel/ChatPage/text_time_vm.dart';
import 'package:flutter/material.dart';

class OwnFileCard extends StatelessWidget {
  const OwnFileCard({
    Key? key,
    required this.path,
    required this.message,
    required this.time,
    required this.timeAfter,
  }) : super(key: key);
  final String path;
  final String message;
  final DateTime time;
  final DateTime timeAfter;

  @override
  Widget build(BuildContext context) {
    NetworkHandler networkHandler = NetworkHandler();
    String url = networkHandler.getURL();
    TextTimeVM textTimeVM = TextTimeVM(time: time);
    String timetext = textTimeVM.getTextTime();
    Duration diff = time.difference(timeAfter);
    return Column(
      children: [
        diff.inMinutes > 9
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  timetext,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              )
            : const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 1.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.green[300],
              ),
              child: Card(
                margin: const EdgeInsets.all(3),
                color: Colors.teal[400],
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: path.length > 17
                          ? Image.file(
                              File(path),
                              fit: BoxFit.fitWidth,
                            )
                          : Image.network(
                              "$url/uploads/$path",
                              fit: BoxFit.fitWidth,
                            ),
                    ),
                    message.isNotEmpty
                        ? Container(
                            height: 40,
                            padding: const EdgeInsets.only(
                              left: 15,
                              top: 8,
                            ),
                            child: Text(
                              message,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
