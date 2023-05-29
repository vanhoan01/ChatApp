// ignore_for_file: file_names

import 'package:chatapp/ViewModel/UserViewModel.dart';
import 'package:flutter/material.dart';

class ChatIDEditScreen extends StatefulWidget {
  const ChatIDEditScreen({super.key, required this.chatID});
  final String chatID;

  @override
  State<ChatIDEditScreen> createState() => _ChatIDEditScreenState();
}

class _ChatIDEditScreenState extends State<ChatIDEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _chatIDController = TextEditingController();
  Color colorSave = Colors.white70;
  bool check = false;
  @override
  void initState() {
    super.initState();
    _chatIDController.text = widget.chatID;
    _chatIDController.selection =
        TextSelection.collapsed(offset: _chatIDController.text.length);
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
          "Chat ID",
          style: TextStyle(fontSize: 16),
        )),
        actions: [
          TextButton(
            child: Text(
              "Lưu",
              style: TextStyle(color: colorSave),
            ),
            onPressed: () {
              if (_chatIDController.text != widget.chatID && check == true) {
                UserViewModel().updateChatID(_chatIDController.text);
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
                controller: _chatIDController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Hãy nhập';
                  }
                  return null;
                },
                maxLength: 24,
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Color.fromRGBO(224, 224, 224, 1)),
                  ),
                  hintText: 'Nhập Chat ID',
                  suffix: check == true
                      ? const Icon(
                          Icons.check_outlined,
                          size: 20,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.close,
                          size: 20,
                          color: Color.fromRGBO(97, 97, 97, 1),
                        ),
                ),
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    if (_chatIDController.text == widget.chatID) {
                      colorSave = Colors.white70;
                      check = false;
                    } else {
                      colorSave = Colors.white;
                      check = true;
                    }
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Bạn chỉ có thể thay đổi Chat ID của mình trong mỗi 30 ngày.",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
