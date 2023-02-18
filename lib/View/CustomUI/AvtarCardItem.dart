import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Model/ChatterModel.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AvtarCardItem extends StatelessWidget {
  const AvtarCardItem({Key? key, required this.contact}) : super(key: key);
  final ChatterModel contact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 23,
            child: SvgPicture.asset(
              'assets/person.svg',
              color: Colors.white,
              height: 30,
              width: 30,
            ),
            backgroundColor: Colors.blueGrey[200],
          ),
          SizedBox(
            height: 2,
          ),
          Text(
            contact.displayName,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
