// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MessagesTextView extends StatefulWidget {
  const MessagesTextView({
    Key? key,
    required this.text,
    required this.reply,
  }) : super(key: key);
  final String text;
  final bool reply;

  @override
  State<MessagesTextView> createState() => _MessagesTextViewState();
}

class _MessagesTextViewState extends State<MessagesTextView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: widget.reply == false
          ? const Color(0xffdcf8c6)
          : Colors.grey.shade200,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 8,
              bottom: 8,
            ),
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 16,
                color:
                    widget.reply == false ? Colors.grey[800] : Colors.grey[600],
              ),
            ),
          ),
          widget.reply == false
              ? const SizedBox(height: 0)
              : const SizedBox(height: 15),
        ],
      ),
    );
  }
}
