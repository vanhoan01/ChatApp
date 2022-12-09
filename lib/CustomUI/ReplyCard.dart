import 'package:chatapp/Services/metwork_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReplyCard extends StatelessWidget {
  const ReplyCard(
      {Key? key,
      required this.path,
      required this.message,
      required this.time,
      required this.isGroup})
      : super(key: key);
  final String message;
  final String time;
  final String path;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    NetworkHandler networkHandler = NetworkHandler();
    String url = networkHandler.getURL();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5, left: 5),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: path != ""
                ? NetworkImage(
                    "$url/uploads/$path",
                  )
                : null,
            // ignore: sort_child_properties_last
            child: path == ""
                ? SvgPicture.asset(
                    isGroup ? 'assets/groups.svg' : 'assets/person.svg',
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
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 45,
            ),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              // color: Color(0xffdcf8c6),
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 60,
                      top: 10,
                      bottom: 20,
                    ),
                    child: Text(
                      message,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 10,
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
      ],
    );
  }
}
