import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class GetMyCoords extends StatefulWidget {
  const GetMyCoords({super.key});

  @override
  State<GetMyCoords> createState() => _GetMyCoordsState();
}

class _GetMyCoordsState extends State<GetMyCoords> {
// RECUPERER LES COORDS DE LA POSITION
  void getPosition() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        openAppSettings();
      } else if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position coords = await Geolocator.getCurrentPosition();
        double lat = coords.latitude;
        double long = coords.longitude;
        sharedPositionMaps(lat, long);
      }
    } catch (e) {
      print(e);
    }
  }

  // PARTAGER LA POSITION SUR LA CARTE MAPS OFFICIEL
  void sharedPositionMaps(lat, long) async {
    final shareUrl = 'https://www.google.com/maps?q=$lat,$long';
    // ignore: deprecated_member_use
    if (await canLaunch(shareUrl)) {
      // ignore: deprecated_member_use
      await launch(shareUrl);
    } else {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Permission",
            style:
                GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w400)),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              getPosition();
            },
            child: Text("Mes coordonnees",
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.w400))),
      ),
    );
  }
}
