// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationShareMap extends StatefulWidget {
  const LocationShareMap({super.key});

  @override
  State<LocationShareMap> createState() => _LocationShareMapState();
}

class _LocationShareMapState extends State<LocationShareMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng choosePossition = const LatLng(16.036505, 108.218186);

  String location = 'Null, Press Button';
  String address = '16.036505, 108.218186';
  // final List<Marker> _markers = <Marker>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(16.036505, 108.218186),
              zoom: 14.4746,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            padding: const EdgeInsets.only(top: 30),
            // markers: Set<Marker>.of(_markers),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraMove: (position) {
              setState(() {
                choosePossition =
                    LatLng(position.target.latitude, position.target.longitude);
              });
            },
          ),
          const Center(
            child: Icon(
              Icons.location_pin,
              size: 45,
              color: Colors.red,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // ignore: avoid_print
          print("choosePossition: $choosePossition");
          await GetAddressFromLatLong(choosePossition);
          // ignore: use_build_context_synchronously
          Navigator.pop(context,
              "${choosePossition.latitude},${choosePossition.longitude}-,-$address");
        },
        child: const Icon(Icons.send),
      ),
    );
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // ignore: non_constant_identifier_names
  Future<void> GetAddressFromLatLong(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];
    // ignore: non_constant_identifier_names
    String Address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    print("place: $place");
    setState(() {
      address = Address;
    });
  }

  // place:       Name: 49,
  // I/flutter (32761):       Street: 49 Nguyễn Văn Linh,
  // I/flutter (32761):       ISO Country Code: VN,
  // I/flutter (32761):       Country: Việt Nam,
  // I/flutter (32761):       Postal code: 550000,
  // I/flutter (32761):       Administrative area: Đà Nẵng,
  // I/flutter (32761):       Subadministrative area: Hải Châu,
  // I/flutter (32761):       Locality: ,
  // I/flutter (32761):       Sublocality: ,
  // I/flutter (32761):       Thoroughfare: Nguyễn Văn Linh,
  // I/flutter (32761):       Subthoroughfare: 49

  // Future<void> myLocation() async {
  //   Position position = await _getGeoLocationPosition();
  //   _markers.add(Marker(
  //     markerId: const MarkerId("2"),
  //     position: LatLng(position.latitude, position.longitude),
  //     infoWindow: const InfoWindow(
  //       title: 'My Current Location',
  //     ),
  //   ));

  //   // specified current users location
  //   CameraPosition cameraPosition = CameraPosition(
  //     target: LatLng(position.latitude, position.longitude),
  //     zoom: 16,
  //   );
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  //   location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
  //   GetAddressFromLatLong(position);
  //   print('location: $location');
  // }
}
