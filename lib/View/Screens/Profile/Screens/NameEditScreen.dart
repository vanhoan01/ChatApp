// ignore_for_file: file_names

import 'package:chatapp/ViewModel/UserViewModel.dart';
import 'package:flutter/material.dart';

class NameEditScreen extends StatefulWidget {
  const NameEditScreen({super.key, required this.displayName});
  final String displayName;

  @override
  State<NameEditScreen> createState() => _NameEditScreenState();
}

class _NameEditScreenState extends State<NameEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  Color colorSave = Colors.black54;
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.displayName;
    _nameController.selection =
        TextSelection.collapsed(offset: _nameController.text.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: TextButton(
          child: const Text(
            "Hủy",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Center(
            child: Text(
          "Sửa tên",
          style: TextStyle(fontSize: 16, color: Colors.black),
        )),
        actions: [
          TextButton(
            child: Text(
              "Lưu",
              style: TextStyle(color: colorSave),
            ),
            onPressed: () {
              if (_nameController.text != widget.displayName) {
                UserViewModel().updateDisplayName(_nameController.text);
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
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Hãy nhập';
                  }
                  return null;
                },
                maxLength: 30,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Color.fromRGBO(224, 224, 224, 1)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  hintText: 'Nhập tên',
                ),
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    _nameController.text == widget.displayName
                        ? colorSave = Colors.black54
                        : colorSave = Colors.black;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Bạn chỉ có thể thay đổi biệt danh sau 7 ngày một lần",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
