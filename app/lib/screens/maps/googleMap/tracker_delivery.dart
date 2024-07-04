import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class TrackerDelivery extends StatefulWidget {
  const TrackerDelivery({super.key});

  @override
  State<TrackerDelivery> createState() => _TrackerDeliveryState();
}

class _TrackerDeliveryState extends State<TrackerDelivery> {
  GoogleMapController? mapController;
  StreamSubscription<Position>? _streamingPosition;
  LatLng _livreurPosition = LatLng(-34.5, 90.5);
  LatLng _currentPosition = LatLng(-9.2, 93.9);
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
      _trackerPositions();
    }

    } catch (e) {
      print(e);
    }
  }


  void _trackerPositions() {
    _streamingPosition = Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _updateMarkers();
      });
      mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition));
    });

    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _livreurPosition = LatLng(-34.52, 90.52);
        _updateMarkers();
      });
    });
  }

  void _updateMarkers() {
    _markers = {
      Marker(
        markerId: const MarkerId("clientId"),
        position: _currentPosition,
        infoWindow: const InfoWindow(title: "Client"),
      ),
      Marker(
        markerId: const MarkerId("deliveryId"),
        position: _livreurPosition,
        infoWindow: const InfoWindow(title: "Delivery"),
      ),
    };
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
        initialCameraPosition: CameraPosition(target: _livreurPosition, zoom: 13),
        markers: _markers,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}
