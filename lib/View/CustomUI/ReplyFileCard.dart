// ignore_for_file: file_names

import 'dart:io';

import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/ViewModel/ChatPage/text_time_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReplyFileCard extends StatefulWidget {
  const ReplyFileCard(
      {Key? key,
      required this.path,
      required this.message,
      required this.time,
      required this.timeAfter,
      required this.avartar,
      required this.isGroup})
      : super(key: key);
  final String message;
  final DateTime time;
  final DateTime timeAfter;
  final String path;
  final String avartar;
  final bool isGroup;

  @override
  State<ReplyFileCard> createState() => _ReplyFileCardState();
}

class _ReplyFileCardState extends State<ReplyFileCard> {
  NetworkHandler networkHandler = NetworkHandler();
  late String url = "";
  late String avt = "";

  void getAvartar(String userName) async {
    var responseAvartar = await networkHandler.get("/user/get/image/$userName");
    setState(() {
      avt = responseAvartar.toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAvartar(widget.avartar);
  }

  @override
  Widget build(BuildContext context) {
    url = networkHandler.getURL();
    TextTimeVM textTimeVM = TextTimeVM(time: widget.time);
    String timetext = textTimeVM.getTextTime();
    Duration diff = widget.time.difference(widget.timeAfter);
    return Column(
      children: [
        diff.inMinutes > 9
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  timetext,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              )
            : const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 5),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: avt != ""
                    ? NetworkImage(
                        "$url/uploads/$avt",
                      )
                    : null,
                // ignore: sort_child_properties_last
                child: avt == ""
                    ? SvgPicture.asset(
                        widget.isGroup
                            ? 'assets/groups.svg'
                            : 'assets/person.svg',
                        color: Colors.white,
                        height: 37,
                        width: 37,
                      )
                    : null,
                backgroundColor: Colors.blueGrey,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[400],
                  ),
                  child: Card(
                    margin: const EdgeInsets.all(1),
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          "$url/uploads/${widget.path}",
                          fit: BoxFit.fitWidth,
                        ),
                        widget.message.isNotEmpty
                            ? Container(
                                height: 28,
                                // ignore: prefer_const_constructors
                                padding: EdgeInsets.only(
                                  left: 8,
                                  top: 8,
                                ),
                                child: Text(
                                  widget.message,
                                  overflow: TextOverflow.ellipsis,
                                  // ignore: prefer_const_constructors
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(left: 163, bottom: 8),
                          child: Text(
                            widget.time.toString().substring(11, 16),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
