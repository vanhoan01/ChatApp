import 'dart:io';

import 'package:chatapp/Services/metwork_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReplyFileCard extends StatelessWidget {
  const ReplyFileCard(
      {Key? key,
      required this.path,
      required this.message,
      required this.time,
      required this.avartar,
      required this.isGroup})
      : super(key: key);
  final String message;
  final String time;
  final String path;
  final String avartar;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    NetworkHandler networkHandler = NetworkHandler();
    String url = networkHandler.getURL();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 5),
          child: CircleAvatar(
            radius: 20,

            backgroundImage: avartar.isNotEmpty
                ? NetworkImage(
                    "$url/uploads/$avartar",
                  )
                : null,
            // ignore: sort_child_properties_last
            child: avartar.isEmpty
                ? SvgPicture.asset(
                    isGroup ? 'assets/groups.svg' : 'assets/person.svg',
                    color: Colors.white,
                    height: 37,
                    width: 37,
                  )
                : Container(),
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
              height: MediaQuery.of(context).size.height / 2.3,
              width: MediaQuery.of(context).size.width / 1.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[400],
              ),
              child: Card(
                margin: EdgeInsets.all(3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.network(
                        "${url}/uploads/$path",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    message.isNotEmpty
                        ? Container(
                            height: 28,
                            // ignore: prefer_const_constructors
                            padding: EdgeInsets.only(
                              left: 8,
                              top: 8,
                            ),
                            child: Text(
                              message,
                              overflow: TextOverflow.ellipsis,
                              // ignore: prefer_const_constructors
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.only(left: 163, bottom: 8),
                      child: Text(
                        time,
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
    );
  }
}
