import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientTrackingDelivery extends StatefulWidget {
  const ClientTrackingDelivery({super.key});

  @override
  State<ClientTrackingDelivery> createState() => _ClientTrackingDeliveryState();
}

class _ClientTrackingDeliveryState extends State<ClientTrackingDelivery> {
  double clientLat = 12.594039180191167;
  double clientLong = -7.940852680927939;

  double deliveryLat = 12.583019129844349;
  double deliveryLong = -7.92946144932868;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  // Partager vers le Google Maps
  void _openMap() async {
    final shareUrl ="https://www.google.com/maps/dir/?api=1&origin=$deliveryLat,$deliveryLong,&destination=$clientLat,$clientLong";
    // ignore: deprecated_member_use
    if (await canLaunch(shareUrl)) {
      // ignore: deprecated_member_use
      await launch(shareUrl);
    } else {
      print("Error launching URL");
    }
  }

  // Demander la permission d'activer la localisation
  Future<void> _requestLocationPermission() async {
    try {
      // LocationPermission permission = await Geolocator.requestPermission();
      // if (permission == LocationPermission.denied ||
      //     permission == LocationPermission.deniedForever) {
      //   openAppSettings();
      // } else if (permission == LocationPermission.whileInUse ||
      //     permission == LocationPermission.always) {
        _startTracking();
      
    } catch (e) {
      print("Error requesting permission: $e");
    }
  }

  // Actualiser les positions
  void _startTracking() async {
    // await getPositionDelivery();
    // Position position = await Geolocator.getCurrentPosition();
    // await sendPosition(position.altitude,position.longitude);
    while (true) {
      // await getPositionDelivery();
      // Position position = await Geolocator.getCurrentPosition();
      // await sendPosition(position.altitude,position.longitude);
      setState(() {
        deliveryLat += 0.0001;
        deliveryLong += 0.0001;
      });
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  // Récupérer les positions du livreur depuis le serveur
  // Future<void> getPositionDelivery() async {
  //   try {

  //   } catch (e) {
  //     print("Error fetching position: $e");
  //   }
  // }

// envoyer les positions du client depuis le serveur
  // Future<void> sendPosition() async {
  //   try {
 
  //   } catch (e) {
  //     print("Error fetching position: $e");
  //   }
  // }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
         leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios_rounded, size:24)),
         
      ),
      body: SizedBox(
        child: Column(
         // mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Padding(
               padding: const EdgeInsets.all(15),
               child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text("Suis le courier jusqu'a chez vous !",style: GoogleFonts.abel(fontSize: 40,fontWeight: FontWeight.bold),),
                        Text("En temps reel",style: GoogleFonts.abel(fontSize: 20,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  Container(
                    height: 200, 
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage("assets/logos/livraison.jpeg"), 
                        fit: BoxFit.cover
                        )
                    ),
                    
                           
                  ),
                ],
                           ),
             ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D1A30),),
                    onPressed: () {
                      _openMap();
                    },
                    child: Text("Suivre le trajet...",
                        style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}