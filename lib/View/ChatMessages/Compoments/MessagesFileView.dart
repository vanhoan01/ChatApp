// ignore_for_file: file_names

import 'dart:io';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class MessagesFileView extends StatefulWidget {
  const MessagesFileView({
    Key? key,
    required this.path,
    required this.reply,
  }) : super(key: key);
  final String path;
  final bool reply;

  @override
  State<MessagesFileView> createState() => _MessagesFileViewState();
}

class _MessagesFileViewState extends State<MessagesFileView> {
  File? _file;
  @override
  void initState() {
    super.initState();
    _file = File('${AppUrl.fileUrl}${widget.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.reply == false
          ? const Color(0xffdcf8c6)
          : Colors.grey.shade200,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        leading: const Icon(Icons.file_present),
        title: Text(basename(_file!.path)),
        subtitle: Text('${_file!.lengthSync()}'),
      ),
    );
  }
}
