// ignore_for_file: file_names

import 'package:chatapp/ViewModel/Profile/UserViewModel.dart';
import 'package:flutter/material.dart';

class LinkEditScreen extends StatefulWidget {
  const LinkEditScreen({super.key, required this.link});
  final String link;

  @override
  State<LinkEditScreen> createState() => _LinkEditScreenState();
}

class _LinkEditScreenState extends State<LinkEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _linkController = TextEditingController();
  Color colorSave = Colors.white70;
  @override
  void initState() {
    super.initState();
    _linkController.text = widget.link;
    _linkController.selection =
        TextSelection.collapsed(offset: _linkController.text.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          child: const Text(
            "Hủy",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Center(
            child: Text(
          "Liên kết",
          style: TextStyle(fontSize: 16),
        )),
        actions: [
          TextButton(
            child: Text(
              "Lưu",
              style: TextStyle(color: colorSave),
            ),
            onPressed: () {
              if (_linkController.text != widget.link) {
                UserViewModel().updateLink(_linkController.text);
                Navigator.pop(context);
              } else {
                null;
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _linkController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Hãy nhập';
                  }
                  return null;
                },
                maxLength: 80,
                maxLines: 5,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Color.fromRGBO(224, 224, 224, 1)),
                  ),
                  hintText: 'Nhập liên kết',
                ),
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    _linkController.text == widget.link
                        ? colorSave = Colors.white70
                        : colorSave = Colors.white;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
