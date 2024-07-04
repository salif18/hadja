import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapsPage extends StatefulWidget {
  final Function(LatLng position) getLatLng;
  const MapsPage({super.key, required this.getLatLng});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(12.652250, -7.981700);
  Set<Marker> myMarkers = {};
  StreamSubscription<Position>? streamingPosition;

  void _autorisationLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        openAppSettings();
      } else if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position coords = await Geolocator.getCurrentPosition();
        setState(() {
          _currentPosition = LatLng(coords.latitude, coords.longitude);
        });
        _updateMarker();
      }
    } catch (e) {
      Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _autorisationLocation();
  }

  void _updateMarker() {
    streamingPosition =
        Geolocator.getPositionStream().listen((Position position) {
      LatLng newPosition = LatLng(position.latitude, position.longitude);
      setState(() {
        myMarkers.add(Marker(
          markerId: const MarkerId("currentLocation"),
          position: newPosition,
        ));
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(newPosition));
    });
  }

  @override
  void dispose() {
    streamingPosition?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: _currentPosition, zoom: 14),
        onTap: (LatLng coords) {
          setState(() {
            _currentPosition = coords;
            widget.getLatLng(coords);
            myMarkers.add(Marker(
              markerId: const MarkerId("selectedLocation"),
              position: coords,
            ));
          });
        },
        mapType: MapType.normal,
        markers: myMarkers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
