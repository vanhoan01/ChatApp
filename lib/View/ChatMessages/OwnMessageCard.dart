// ignore_for_file: file_names

import 'package:chatapp/Model/Model/ChatMessagesModel.dart';
import 'package:chatapp/Model/Model/ReactModel.dart';
import 'package:chatapp/View/ChatMessages/Compoments/MessagesFileView.dart';
import 'package:chatapp/View/ChatMessages/Compoments/MessagesImageView.dart';
import 'package:chatapp/View/ChatMessages/Compoments/MessagesTextView.dart';
import 'package:chatapp/View/ChatPage/Compoments/PopupMenuWidget.dart';
import 'package:chatapp/ViewModel/ChatPage/ChatMessagesViewModel.dart';
import 'package:chatapp/ViewModel/ChatPage/text_time_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OwnMessageCard extends StatefulWidget {
  const OwnMessageCard({
    Key? key,
    required this.userId,
    required this.chatMM,
    required this.timeAfter,
    this.setReply,
  }) : super(key: key);
  final String userId;
  final ChatMessagesModel chatMM;
  final DateTime timeAfter;
  final Function(String, String, String)? setReply;

  @override
  State<OwnMessageCard> createState() => _OwnMessageCardState();
}

class _OwnMessageCardState extends State<OwnMessageCard> {
  Offset _tapPosition = Offset.zero;
  ChatMessagesViewModel chatMessagesViewModel = ChatMessagesViewModel();
  ChatMessagesModel? chatReply;

  @override
  void initState() {
    getChatReply();
    super.initState();
  }

  void getChatReply() async {
    if (widget.chatMM.reply != "") {
      ChatMessagesModel data =
          await chatMessagesViewModel.getMessageByID(widget.chatMM.reply ?? "");

      setState(() {
        chatReply = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(alignment: Alignment.bottomCenter, child: timeView()),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            widget.chatMM.reply != ""
                ? ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 1.5,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: widget.chatMM.reacts != null
                              ? widget.chatMM.reacts!.isNotEmpty
                                  ? 40
                                  : 20
                              : 20),
                      child: widget.chatMM.type == "text"
                          ? MessagesTextView(
                              text: chatReply != null ? chatReply!.text : "",
                              reply: true,
                            )
                          : MessagesImageView(
                              path: chatReply != null ? chatReply!.text : "",
                              reply: true,
                            ),
                    ),
                  )
                : Container(),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.5,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: widget.chatMM.reacts != null
                      ? widget.chatMM.reacts!.isNotEmpty
                          ? 20
                          : 0
                      : 0,
                  top: 5,
                ),
                child: GestureDetector(
                  onLongPress: () {
                    showModalBottomSheet<void>(
                      context: context,
                      barrierColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return bottomMenu();
                      },
                    );
                    _showContextMenu(context);
                  },
                  onTapDown: (details) => _getTapPosition(details),
                  child: widget.chatMM.type == "text"
                      ? MessagesTextView(
                          text: widget.chatMM.text,
                          reply: false,
                        )
                      : widget.chatMM.type == "image"
                          ? MessagesImageView(
                              path: widget.chatMM.text,
                              reply: false,
                            )
                          : MessagesFileView(
                              path: widget.chatMM.text,
                              reply: false,
                            ),
                ),
              ),
            ),
            widget.chatMM.reacts != null
                ? widget.chatMM.reacts!.isNotEmpty
                    ? reactionsView()
                    : Container()
                : Container(),
          ],
        ),
      ],
    );
  }

  Widget timeView() {
    TextTimeVM textTimeVM = TextTimeVM(time: widget.chatMM.timestamp);
    String timetext = textTimeVM.getTextTime();
    Duration diff = widget.chatMM.timestamp.difference(widget.timeAfter);
    return diff.inMinutes > 9
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              timetext,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          )
        : const SizedBox(height: 10);
  }

  Widget reactionsView() {
    return Positioned(
      right: 0,
      bottom: 1,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: const Color(0xffdcf8c6),
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              reactShow(),
              Text(
                '${widget.chatMM.reacts!.isEmpty ? 0 : widget.chatMM.reacts!.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getTapPosition(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.localPosition);
    });
  }

  void _showContextMenu(BuildContext context) async {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    // ignore: avoid_print
    print(
        '_tapPosition.dx, _tapPosition.dy ${_tapPosition.dx}, ${_tapPosition.dy}');
    await showMenu(
      elevation: 1,
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy * (-1), 0, 0),
        Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
            overlay.paintBounds.size.height),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      items: [
        PopupMenuWidget(
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                reactView('img_love.png', 'love'),
                reactView('img_laugh.png', 'laugh'),
                reactView('img_wow.png', 'wow'),
                reactView('img_sad.png', 'sad'),
                reactView('img_angry.png', 'angry'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  int statusCounter(String reactKey) {
    int counter = 0;
    for (var react in widget.chatMM.reacts ?? []) {
      if (react.react == reactKey) counter += 1;
    }
    return counter;
  }

  Widget reactShow() {
    List<ReactCount> reacts = [
      ReactCount('love', 0),
      ReactCount('laugh', 0),
      ReactCount('wow', 0),
      ReactCount('sad', 0),
      ReactCount('angry', 0),
    ];
    for (int i = 0; i < reacts.length; i++) {
      reacts[i].quantity = statusCounter(reacts[i].name);
    }
    reacts.sort((a, b) => b.quantity.compareTo(a.quantity));
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var react in reacts)
          if (react.quantity > 0)
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Image.asset(
                'assets/images/img_${react.name}.png',
                height: 15,
                width: 15,
              ),
            ),
      ],
    );
  }

  int checkUserReact(String reactKey) {
    if (widget.chatMM.reacts!
        .where(
            (react) => react.userId == widget.userId && react.react == reactKey)
        .isNotEmpty) {
      return 2; //thả cảm xúc là reactKey
    }
    if (widget.chatMM.reacts!
        .where((react) => react.userId == widget.userId)
        .isNotEmpty) {
      return 1; //thả cảm xúc khác reactKey
    }
    return 0; //không thả cảm xúc
  }

  Widget reactView(String reactImg, String reactKey) {
    return IconButton(
      icon: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: checkUserReact(reactKey) == 2
              ? Colors.grey.shade300
              : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset('assets/images/$reactImg'),
        ),
      ),
      iconSize: 28,
      onPressed: () {
        reactMessenger(reactKey);
      },
    );
  }

  void reactMessenger(String reactKey) {
    int check = checkUserReact(reactKey);

    if (check == 2) {
      //remove
      setState(() {
        widget.chatMM.reacts!
            .removeWhere((item) => item.userId == widget.userId);
      });
      ChatMessagesViewModel()
          .deleteReacts(widget.chatMM.id ?? "", widget.userId);
    } else if (check == 1) {
      //update
      setState(() {
        widget
            .chatMM
            .reacts![widget.chatMM.reacts!
                .indexWhere((item) => item.userId == widget.userId)]
            .react = reactKey;
      });
      ChatMessagesViewModel()
          .updateReacts(widget.chatMM.id ?? "", widget.userId, reactKey);
    } else {
      ChatMessagesViewModel()
          .addReacts(widget.chatMM.id ?? "", widget.userId, reactKey);
      setState(() {
        widget.chatMM.reacts!
            .add(ReactModel(userId: widget.userId, react: reactKey));
      });
    }

    Navigator.pop(context);
  }

  void _showSeeMore(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => Center(
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  "Tin nhắn",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              optionMore("Chuyển tiếp", () => null),
              optionMore("Nhắc lại", () => null),
              optionMore("Gỡ", () => null),
            ],
          ),
        ),
      ),
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
            widget.setReply!(widget.chatMM.id ?? "", widget.chatMM.author,
                widget.chatMM.text);
            //https://www.digitalocean.com/community/tutorials/flutter-widget-communication
            Navigator.pop(context);
          },
        ),
        option(
          Icons.copy,
          "Sao chép",
          () {
            Clipboard.setData(ClipboardData(text: widget.chatMM.text));
            Navigator.pop(context);
          },
        ),
        option(
          Icons.push_pin_rounded,
          "Ghim",
          () {
            // ignore: avoid_print
            print("Ghim");
          },
        ),
        option(
          Icons.more_horiz_rounded,
          "Xem thêm",
          () {
            _showSeeMore(context);
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

  Widget optionMore(String text, Function() function) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: Colors.black,
        alignment: Alignment.centerLeft,
        textStyle: const TextStyle(fontSize: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      onPressed: function,
      child: Text(text),
    );
  }
}

class ReactCount {
  String name;
  int quantity;
  ReactCount(this.name, this.quantity);
}
