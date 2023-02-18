// ignore_for_file: file_names

import 'package:chatapp/View/ChatPage/Compoments/PopupMenuWidget.dart';
import 'package:chatapp/ViewModel/ChatPage/text_time_vm.dart';
import 'package:flutter/material.dart';

class OwnMessageCard extends StatefulWidget {
  const OwnMessageCard({
    Key? key,
    required this.message,
    required this.time,
    required this.timeAfter,
  }) : super(key: key);
  final String message;
  final DateTime time;
  final DateTime timeAfter;

  @override
  State<OwnMessageCard> createState() => _OwnMessageCardState();
}

class _OwnMessageCardState extends State<OwnMessageCard> {
  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.localPosition);
    });
  }

  void _showContextMenu(BuildContext context) async {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    print(
        '_tapPosition.dx, _tapPosition.dy ${_tapPosition.dx}, ${_tapPosition.dy}');

    final result = await showMenu(
      context: context,

      // Show the context menu at the tap location
      position: RelativeRect.fromRect(
          Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy * (-1), 0, 0),
          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
              overlay.paintBounds.size.height)),

      // set a list of choices for the context menu
      items: [
        PopupMenuWidget(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(
                  Icons.face,
                  size: 30,
                ),
                Icon(
                  Icons.face,
                  size: 30,
                ),
                Icon(
                  Icons.face,
                  size: 30,
                ),
                Icon(
                  Icons.face,
                  size: 30,
                ),
                Icon(
                  Icons.face,
                  size: 30,
                ),
              ],
            ),
          ),
        ),
      ],
    );

    // Implement the logic for each choice here
  }

  @override
  Widget build(BuildContext context) {
    TextTimeVM textTimeVM = TextTimeVM(time: widget.time);
    String timetext = textTimeVM.getTextTime();
    Duration diff = widget.time.difference(widget.timeAfter);
    // print('diff.inMinutes: ${diff.inMinutes}');
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
        GestureDetector(
          onLongPress: () {
            _showContextMenu(context);
            showModalBottomSheet<void>(
              context: context,
              barrierColor: Colors.transparent,
              builder: (BuildContext context) {
                return bottomMenu();
              },
            );
          },
          onTapDown: (details) => _getTapPosition(details),
          child: Align(
            alignment: Alignment.centerRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 45,
              ),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: const Color(0xffdcf8c6),
                margin: const EdgeInsets.symmetric(horizontal: 15),
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
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 10,
                      child: Row(
                        children: [
                          Text(
                            widget.time.toString().substring(11, 16),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.done_all,
                            size: 20,
                          ),
                        ],
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

  Widget bottomMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        option(
          Icons.share,
          "Phản hồi",
          () {
            print("Phản hồi");
          },
        ),
        option(
          Icons.copy,
          "Sao chép",
          () {
            print("Sao chép");
          },
        ),
        option(
          Icons.push_pin_rounded,
          "Ghim",
          () {
            print("Ghim");
          },
        ),
        option(
          Icons.more_horiz_rounded,
          "Xem thêm",
          () {
            print("Xem thêm");
          },
        ),
      ],
    );
  }

  Widget option(IconData icon, String text, Function() function) {
    return InkWell(
      onTap: function,
      child: SizedBox(
        height: 80,
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon),
            const SizedBox(
              height: 3,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
