// ignore_for_file: file_names

import 'package:chatapp/Model/Model/ChatterModel.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/ViewModel/Profile/ChatterViewModel.dart';
import 'package:flutter/material.dart';

class ReactHistoryView extends StatefulWidget {
  const ReactHistoryView({
    Key? key,
    required this.author,
    required this.cotent,
    required this.type,
  }) : super(key: key);
  final String cotent;
  final String type;
  final String author;

  @override
  State<ReactHistoryView> createState() => _ReactHistoryViewState();
}

class _ReactHistoryViewState extends State<ReactHistoryView> {
  ChatterModel? chatterModel;
  ChatterViewModel chatterViewModel = ChatterViewModel();

  @override
  void initState() {
    super.initState();
    getChatterModel();
  }

  void getChatterModel() async {
    ChatterModel data = await chatterViewModel.getChatterModel(widget.author);
    setState(() {
      chatterModel = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 2),
        child: ListTile(
          leading: Stack(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.shade300,
                ),
                child: widget.type == "file"
                    ? const Icon(
                        Icons.file_present,
                        size: 36,
                      )
                    : widget.type == "image"
                        ? Image.network("${AppUrl.imageUrl}${widget.cotent}")
                        : widget.type == "audio"
                            ? const Icon(Icons.audio_file_rounded)
                            : const Icon(
                                Icons.textsms_outlined,
                                size: 36,
                              ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: CircleAvatar(
                  radius: 11,
                  backgroundColor: Colors.blueGrey[200],
                  backgroundImage: NetworkImage(
                      "${AppUrl.imageUrl}${chatterModel != null ? chatterModel!.avatarImage : ""}"),
                ),
              )
            ],
          ),
          title: Text(widget.type == "image" ? "Hình ảnh" : widget.cotent),
          subtitle: Text(chatterModel != null ? chatterModel!.displayName : ""),
        ),
      ),
    );
  }
}
