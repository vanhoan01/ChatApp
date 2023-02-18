// ignore_for_file: file_names

import 'package:flutter/material.dart';

class PopupMenuWidget extends PopupMenuEntry {
  const PopupMenuWidget({
    Key? key,
    required this.height,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  final double height;

  @override
  State<PopupMenuWidget> createState() => PopupMenuWidgetState();

  @override
  bool represents(value) => true;
}

class PopupMenuWidgetState extends State<PopupMenuWidget> {
  @override
  Widget build(BuildContext context) => widget.child;
}
