// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MessagesForwardView extends StatefulWidget {
  const MessagesForwardView({
    Key? key,
    required this.text,
    required this.reply,
    required this.color,
  }) : super(key: key);
  final String text;
  final bool reply;
  final bool color;

  @override
  State<MessagesForwardView> createState() => _MessagesForwardViewState();
}

class _MessagesForwardViewState extends State<MessagesForwardView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: widget.color ? Colors.blue : Colors.grey.shade200,
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
                color: widget.color ? Colors.white : Colors.black,
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
