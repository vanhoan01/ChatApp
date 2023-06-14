// ignore_for_file: file_names

import 'dart:io';

import 'package:chatapp/Resources/app_urls.dart';
import 'package:flutter/material.dart';

class MessagesImageView extends StatefulWidget {
  const MessagesImageView({
    Key? key,
    required this.path,
    required this.reply,
    required this.color,
  }) : super(key: key);
  final String path;
  final bool reply;
  final bool color;

  @override
  State<MessagesImageView> createState() => _MessagesImageViewState();
}

class _MessagesImageViewState extends State<MessagesImageView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.color ? Colors.blue : Colors.grey.shade200,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.path.length > 17
              ? Image.file(
                  File(widget.path),
                  fit: BoxFit.fitWidth,
                )
              : Image.network(
                  "${AppUrl.imageUrl}${widget.path}",
                  fit: BoxFit.fitWidth,
                ),
          widget.reply == false
              ? const SizedBox(height: 0)
              : const SizedBox(height: 15),
        ],
      ),
    );
  }
}
