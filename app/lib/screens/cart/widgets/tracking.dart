import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class TrackingMaps extends StatefulWidget {
  const TrackingMaps({super.key});

  @override
  State<TrackingMaps> createState() => _TrackingMapsState();
}

class _TrackingMapsState extends State<TrackingMaps> {

  GoogleMapController? _mapController;
  LatLng _currentPosition = LatLng(23.4566, -12.34);
  Set<Marker> _markers = {};
  StreamSubscription<Position>? streamingPosition;

  void _autorisationLocation()async{
      try{
         LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
         openAppSettings();
      } else if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
            Position coords = await Geolocator.getCurrentPosition();
            setState(() {
              _currentPosition = LatLng(coords.latitude,coords.longitude);
            });
            _updateMarker();
          }
      }catch(e){
        print(e);
      }
  }

  @override
  void initState() {
    super.initState();
    _autorisationLocation();
  }

  _updateMarker() {
    streamingPosition =
        Geolocator.getPositionStream().listen((Position position) {
      LatLng newPosition = LatLng(position.latitude, position.longitude);
      setState(() {
        _markers.add(Marker(
          markerId: MarkerId("value"),
          position: newPosition,
        ));
      });
      _mapController!.animateCamera(CameraUpdate.newLatLng(newPosition));
    });
  }

  @override
  void dispose() {
    streamingPosition!.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
      initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 14),
      onTap: (LatLng coords) {
        setState(() {
          _currentPosition = coords;
          _markers.add(Marker(
            markerId: MarkerId("tapvalue"),
            position: coords,
          ));
        });
      },
      mapType: MapType.normal,
      markers: _markers,
      onMapCreated: (controller) {
        _mapController = controller;
      },
    ),
    );
  }
}