// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MessagesCallView extends StatefulWidget {
  const MessagesCallView({
    Key? key,
    required this.myUserName,
    required this.author,
    required this.partition,
    required this.type,
    required this.callTime,
    required this.isGroup,
    required this.color,
  }) : super(key: key);

  final String myUserName;
  final String author;
  final String partition;
  final String type;
  final int callTime;
  final bool isGroup;
  final bool color;

  @override
  State<MessagesCallView> createState() => _MessagesCallViewState();
}

class _MessagesCallViewState extends State<MessagesCallView> {
  Icon iconCall() {
    IconData iconData;
    if (widget.myUserName == widget.author) {
      iconData = Icons.call_made;
    } else if (widget.type == "Missed call") {
      iconData = Icons.call_missed;
    } else {
      iconData = Icons.call_received;
    }
    return Icon(iconData);
  }

  String textCall() {
    String text;
    if (widget.myUserName == widget.author) {
      text = "Cuộc gọi đi";
    } else if (widget.type == "Missed call") {
      text = "Cuộc gọi nhỡ";
    } else {
      text = "Cuộc gọi đến";
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.color ? Colors.blue : Colors.grey.shade200,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
              child: iconCall(),
            ),
            title: Text(
              textCall(),
              style: TextStyle(
                color: widget.color ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              '${widget.callTime} giây',
              style: TextStyle(
                color: widget.color ? Colors.white : Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(40),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {},
              child: const Text('Gọi lại'),
            ),
          ),
        ],
      ),
    );
  }
}
