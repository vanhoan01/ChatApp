import 'package:chatapp/CustomUI/StatusPage/HeadOwnStatus.dart';
import 'package:chatapp/CustomUI/StatusPage/OthersStatus.dart';
import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 48,
            child: FloatingActionButton(
              backgroundColor: Colors.blueGrey[100],
              elevation: 8,
              onPressed: () {},
              child: Icon(
                Icons.edit,
                color: Colors.blueGrey[900],
              ),
            ),
          ),
          SizedBox(
            height: 13,
          ),
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.greenAccent[700],
            elevation: 5,
            child: Icon(Icons.camera_alt),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(
            //   height: 10,
            // ),
            HeadOwnStatus(),
            label("Recent updates"),
            OthersStatus(
              name: "Balram Rathore",
              time: "01:56",
              imageName: "assets/1.jpg",
              isSeen: true,
              statusNum: 1,
            ),
            OthersStatus(
              name: "Saket Sinha",
              time: "02:08",
              imageName: "assets/2.jpg",
              isSeen: true,
              statusNum: 2,
            ),
            OthersStatus(
              name: "Butcher Wiliam",
              time: "05:46",
              imageName: "assets/3.jpg",
              isSeen: false,
              statusNum: 3,
            ),
            SizedBox(
              height: 10,
            ),
            label("Viewed updates "),
            OthersStatus(
              name: "Balram Rathore",
              time: "01:56",
              imageName: "assets/1.jpg",
              isSeen: true,
              statusNum: 1,
            ),
            OthersStatus(
              name: "Saket Sinha",
              time: "02:08",
              imageName: "assets/2.jpg",
              isSeen: true,
              statusNum: 2,
            ),
            OthersStatus(
              name: "Butcher Wiliam",
              time: "05:46",
              imageName: "assets/3.jpg",
              isSeen: true,
              statusNum: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget label(String lablename) {
    return Container(
      height: 33,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        child: Text(
          lablename,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
