import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/orders_api.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/orders_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryTrackingClient extends StatefulWidget {
  final OrdersModel order;
  const DeliveryTrackingClient({super.key, required this.order});

  @override
  State<DeliveryTrackingClient> createState() => _DeliveryTrackingClientState();
}

class _DeliveryTrackingClientState extends State<DeliveryTrackingClient> {
  ServicesApiOrders api = ServicesApiOrders();
  late double clientLat;
  late double clientLong;

  double deliveryLat = 12.583019129844349;
  double deliveryLong = -7.92946144932868;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  // Partager vers le Google Maps
  void _openMap() async {
    final shareUrl =
        "https://www.google.com/maps/dir/?api=1&origin=$deliveryLat,$deliveryLong&destination=$clientLat,$clientLong";
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
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        openAppSettings();
      } else {
        _startTracking();
      }
    } catch (e) {
      print("Error requesting permission: $e");
    }
  }

  // Actualiser les positions
  void _startTracking() async {
    await fetchPositionDeliveryAndClient();
    Position position = await Geolocator.getCurrentPosition();
    await sendPosition(position.latitude, position.longitude);
    while (true) {
      await fetchPositionDeliveryAndClient();
      position = await Geolocator.getCurrentPosition();
      setState(() {
        deliveryLat = position.latitude;
        deliveryLong = position.longitude;
      });
      await sendPosition(position.latitude, position.longitude);
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  // Récupérer les positions du client depuis le serveur
  Future<void> fetchPositionDeliveryAndClient() async {
    try {
      final res = await api.getOneOrderPositions(widget.order.id);
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        print(body);
        setState(() {
          clientLat = body["clientLat"];
          clientLong = body["clientLong"];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // Envoyer les positions du livreur au serveur
  Future<void> sendPosition(double lat, double long) async {
    var data = {"deliveryNewLat": lat, "deliveryNewLong": long};
    try {
      final res = await api.updateOrderPositions(data, widget.order.id);
      if (res.statusCode == 200) {
        print("Positions mis a jours successfully");
      } else {
        print("Failed to update positions: ${res.body}");
      }
    } catch (e) {
      print("Error sending position: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded, size:AppSizes.iconLarge),
        ),
      ),
      body: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Suis la trajectoire jusqu'au client !",
                          style: GoogleFonts.abel(
                              fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "En temps réel",
                          style: GoogleFonts.abel(
                              fontSize: AppSizes.fontLarge, fontWeight: FontWeight.bold),
                        ),
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
                          fit: BoxFit.cover),
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
                      backgroundColor: const Color(0xFF1D1A30)),
                  onPressed: _openMap,
                  child: Text("Démarrer...",
                      style: GoogleFonts.roboto(
                          fontSize: AppSizes.fontSmall,
                          fontWeight: FontWeight.w400,
                          color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
