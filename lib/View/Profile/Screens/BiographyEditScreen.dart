// ignore_for_file: file_names

import 'package:chatapp/ViewModel/Profile/UserViewModel.dart';
import 'package:flutter/material.dart';

class BiographyEditScreen extends StatefulWidget {
  const BiographyEditScreen({super.key, required this.biography});
  final String biography;

  @override
  State<BiographyEditScreen> createState() => _BiographyEditScreenState();
}

class _BiographyEditScreenState extends State<BiographyEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _biographyController = TextEditingController();
  Color colorSave = Colors.white70;
  @override
  void initState() {
    super.initState();
    _biographyController.text = widget.biography;
    _biographyController.selection =
        TextSelection.collapsed(offset: _biographyController.text.length);
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
          "Tiểu sử",
          style: TextStyle(fontSize: 16),
        )),
        actions: [
          TextButton(
            child: Text(
              "Lưu",
              style: TextStyle(color: colorSave),
            ),
            onPressed: () {
              if (_biographyController.text != widget.biography) {
                UserViewModel().updateBiography(_biographyController.text);
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
                controller: _biographyController,
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
                  hintText: 'Nhập tiểu sử',
                ),
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    _biographyController.text == widget.biography
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
