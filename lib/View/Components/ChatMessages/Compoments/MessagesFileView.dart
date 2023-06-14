// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MessagesFileView extends StatefulWidget {
  const MessagesFileView({
    Key? key,
    required this.name,
    required this.size,
    this.reply,
    required this.color,
  }) : super(key: key);
  final String name;
  final int size;
  final bool? reply;
  final bool color;

  @override
  State<MessagesFileView> createState() => _MessagesFileViewState();
}

class _MessagesFileViewState extends State<MessagesFileView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.color ? Colors.blue : Colors.grey.shade200,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color.fromRGBO(238, 238, 238, 1),
          child: Icon(Icons.file_present),
        ),
        title: Text(widget.name,
            style: TextStyle(
              color: widget.color ? Colors.white : Colors.black,
            )),
        subtitle: Text('${widget.size}',
            style: TextStyle(
              color: widget.color ? Colors.white : Colors.black,
            )),
      ),
    );
  }
}
