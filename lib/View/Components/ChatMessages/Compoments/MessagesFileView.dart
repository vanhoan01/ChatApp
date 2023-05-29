// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MessagesFileView extends StatefulWidget {
  const MessagesFileView({
    Key? key,
    required this.name,
    required this.size,
    this.reply,
  }) : super(key: key);
  final String name;
  final int size;
  final bool? reply;

  @override
  State<MessagesFileView> createState() => _MessagesFileViewState();
}

class _MessagesFileViewState extends State<MessagesFileView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.reply == null
          ? const Color(0xffdcf8c6)
          : widget.reply == false
              ? const Color(0xffdcf8c6)
              : Colors.grey.shade200,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color.fromRGBO(238, 238, 238, 1),
          child: Icon(Icons.file_present),
        ),
        title: Text(widget.name),
        subtitle: Text('${widget.size}'),
      ),
    );
  }
}
