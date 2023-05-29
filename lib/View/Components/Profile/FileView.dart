// ignore_for_file: file_names

import 'package:flutter/material.dart';

class FileView extends StatefulWidget {
  const FileView({
    Key? key,
    required this.name,
    required this.size,
  }) : super(key: key);
  final String name;
  final int size;

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 2),
        child: ListTile(
          leading: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.shade300,
            ),
            child: const Icon(
              Icons.file_present,
              size: 36,
            ),
          ),
          title: Text(widget.name),
          subtitle: Text('${(widget.size / 1000).round()} kb'),
        ),
      ),
    );
  }
}
