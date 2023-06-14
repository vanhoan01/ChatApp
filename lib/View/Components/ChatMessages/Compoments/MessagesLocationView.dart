// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MessagesLocationView extends StatefulWidget {
  const MessagesLocationView({
    Key? key,
    required this.name,
    this.reply,
    required this.color,
  }) : super(key: key);
  final String name;
  final bool? reply;
  final bool color;

  @override
  State<MessagesLocationView> createState() => _MessagesLocationViewState();
}

class _MessagesLocationViewState extends State<MessagesLocationView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final List<Marker> _markers = <Marker>[];
  LatLng initPosition = const LatLng(16.036505, 108.218186);
  String address = "";
  @override
  void initState() {
    super.initState();
    List<String> rs = widget.name.split("-,-");
    print("rs: $rs");
    String position = rs[0];
    List<String> latlng = position.split(',');
    double lat = double.parse(latlng[0]);
    double lng = double.parse(latlng[1]);
    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId("2"),
        position: LatLng(lat, lng),
        infoWindow: const InfoWindow(
          title: 'My Current Location',
        ),
      ));
      initPosition = LatLng(lat, lng);
      address = rs[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.color ? Colors.blue : Colors.grey.shade200,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 150,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initPosition,
                zoom: 14.4746,
              ),
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: Set<Marker>.of(_markers),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Vị trí đã ghim",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: widget.color ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(address,
              maxLines: 2,
              style: TextStyle(
                color: widget.color ? Colors.white : Colors.black,
              )),
        ],
      ),
    );
  }
}
