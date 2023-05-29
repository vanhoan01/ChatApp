// ignore_for_file: file_names

import 'package:chatapp/Model/Model/ChatterModel.dart';

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
            backgroundColor: Colors.blueGrey[200],
            child: SvgPicture.asset(
              'assets/person.svg',
              color: Colors.white,
              height: 30,
              width: 30,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            contact.displayName,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
