// ignore_for_file: file_names

import 'package:chatapp/ViewModel/ChatPage/text_time_vm.dart';
import 'package:flutter/material.dart';

class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard({
    Key? key,
    required this.message,
    required this.time,
    required this.timeAfter,
  }) : super(key: key);
  final String message;
  final DateTime time;
  final DateTime timeAfter;

  @override
  Widget build(BuildContext context) {
    TextTimeVM textTimeVM = TextTimeVM(time: time);
    String timetext = textTimeVM.getTextTime();
    Duration diff = time.difference(timeAfter);
    // print('diff.inMinutes: ${diff.inMinutes}');
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
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 45,
            ),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Color(0xffdcf8c6),
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 60,
                      top: 10,
                      bottom: 20,
                    ),
                    child: Text(
                      message,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 10,
                    child: Row(
                      children: [
                        Text(
                          time.toString().substring(11, 16),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.done_all,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
