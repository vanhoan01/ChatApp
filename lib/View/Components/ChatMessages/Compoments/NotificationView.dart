// ignore_for_file: file_names

import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 12,
        bottom: 8,
      ),
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    );
  }
}
