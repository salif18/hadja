import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class TrackerClient extends StatefulWidget {
  const TrackerClient({super.key});

  @override
  State<TrackerClient> createState() => _TrackerClientState();
}

class _TrackerClientState extends State<TrackerClient> {
  GoogleMapController? mapController;
    StreamSubscription<Position>? _streamingPosition;
  LatLng _currentPosition = const LatLng(-23.5505, -46.6333); // Initial position different from client
  final LatLng _clientPosition = const LatLng(-23.566, 234.78);
  Set<Marker> _markers = {};

  // @override
  // void initState() {
  //   super.initState();
  //   _autorisationGeolocalisation();
  // }

  void _autorisationGeolocalisation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      openAppSettings();
    } else if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      _trackerMap();
    }

    } catch (e) {
      print(e);
    }
  }

 
  void _trackerMap() {
    _streamingPosition = Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _markers = {
          Marker(
            markerId: const MarkerId("livreurId"),
            position: _currentPosition,
            infoWindow: const InfoWindow(
              title: "Livreur",
            ),
          ),
          Marker(
            markerId: const MarkerId("clientId"),
            position: _clientPosition,
            infoWindow: const InfoWindow(title: "Client"),
          ),
        };
      });
      mapController?.animateCamera(
        CameraUpdate.newLatLng(_currentPosition),
      );
    });
  }

   @override 
void dispose(){
  _streamingPosition!.cancel();
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _clientPosition, zoom: 13),
        markers: _markers,
        onMapCreated: (controller) {
          mapController = controller;
          // Center the camera to the current position after map is created
          mapController?.animateCamera(
            CameraUpdate.newLatLng(_currentPosition),
          );
        },
      ),
    );
  }
}
