import 'package:chatapp/Services/metwork_handler.dart';
import 'package:chatapp/ViewModel/ChatPage/text_time_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReplyCard extends StatefulWidget {
  const ReplyCard(
      {Key? key,
      required this.avartar,
      required this.message,
      required this.time,
      required this.timeAfter,
      required this.isGroup})
      : super(key: key);
  final String message;
  final DateTime time;
  final DateTime timeAfter;
  final String avartar;
  final bool isGroup;

  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
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
              padding: const EdgeInsets.only(bottom: 5, left: 5),
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
                          widget.message,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 10,
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
          ],
        ),
      ],
    );
  }
}
