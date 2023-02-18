// ignore_for_file: file_names

import 'dart:math';

import 'package:chatapp/Data/Services/network_handler.dart';
import 'package:chatapp/Model/Model/OthersStatusModel.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:flutter/material.dart';

class OthersStatusWidget extends StatelessWidget {
  const OthersStatusWidget({Key? key, required this.othersStatusModel})
      : super(key: key);
  final OthersStatusModel othersStatusModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
              "${AppUrl.baseUrl}/uploads/${othersStatusModel.avatarImage}",
            ),
          ),
          const Positioned(
            bottom: -2.5,
            right: -2.5,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.circle,
                size: 12,
                color: Color.fromRGBO(0, 200, 83, 1),
              ),
            ),
          )
        ],
      ),
      title: Text(
        othersStatusModel.displayName,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: othersStatusModel.isGroup == true
          ? Text(
              "Hoàn và 1 người khác đang hoạt động",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            )
          : null,
    );
  }
}

degreeToAngle(double degree) {
  return degree * pi / 180;
}

class StatusPainter extends CustomPainter {
  bool isSeen;
  int statusNum;
  StatusPainter({required this.isSeen, required this.statusNum});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 6.0
      ..color = isSeen ? Colors.grey : Color(0xff21bfa6)
      ..style = PaintingStyle.stroke;
    drawArc(canvas, size, paint);
  }

  void drawArc(Canvas canvas, Size size, Paint paint) {
    if (statusNum == 1) {
      canvas.drawArc(Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          degreeToAngle(0), degreeToAngle(360), false, paint);
    } else {
      double degree = -90;
      double arc = 360 / statusNum;
      for (int i = 0; i < statusNum; i++) {
        canvas.drawArc(Rect.fromLTWH(0.0, 0.0, size.width, size.height),
            degreeToAngle(degree + 4), degreeToAngle(arc - 4), false, paint);
        degree += arc;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
