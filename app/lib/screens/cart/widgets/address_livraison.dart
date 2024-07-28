// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hadja_grish/api/orders_api.dart';
import 'package:hadja_grish/providers/auth_provider.dart';
import 'package:hadja_grish/providers/cart_provider.dart';
import 'package:hadja_grish/screens/cart/widgets/maps.dart';
import 'package:provider/provider.dart';

class AddressLivraison extends StatefulWidget {
  const AddressLivraison({super.key});

  @override
  State<AddressLivraison> createState() => _AddressLivraisonState();
}

class _AddressLivraisonState extends State<AddressLivraison> {
  ServicesApiOrders api = ServicesApiOrders();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController address = TextEditingController();
  final TextEditingController telephone = TextEditingController();
  double lat = 12.652250;
  double long = -7.981700;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    address.dispose();
    telephone.dispose();
    super.dispose();
  }

  void getLatLng(LatLng position) {
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
  }

  Future<void> sendOrders() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    final totalProvider = Provider.of<CartProvider>(context, listen: false);
    final total = totalProvider.calculateTotal();
    final cartprovider = Provider.of<CartProvider>(context, listen: false);
    final cart = cartprovider.myCart;
    try {
      Map<String, dynamic> order = {
        "userId": userId,
        "deliberyId": null,
        "address": address.text,
        "latitude": lat,
        "longitude": long,
        "telephone": telephone.text,
        "total": total,
        "statut_of_delibery": "En attente",
        "articles":cart   // jsonEncode(cart.map((item) => item.toJson()).toList()),
      };
      final response = await api.postOrders(order);
      final body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        cartprovider.clearCart();
        api.showSnackBarSuccessPersonalized(context, body["message"]);
      }else{
      api.showSnackBarErrorPersonalized(context, body["message"]);
      }
    } catch (e) {
      Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width,
      
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xfff0fcf3),
          ),
          child: SingleChildScrollView(child: _formulaires(context)),
        ),
      ),
    );
  }

  Widget _formulaires(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Faites-vous livrer chez vous !",
                  style: GoogleFonts.abel(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Remplissez bien les renseignements",
                  style: GoogleFonts.abel(fontSize: 20),
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: const DecorationImage(
                image: AssetImage("assets/logos/delibery.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: address,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Quartier",
                hintStyle: GoogleFonts.aBeeZee(
                    fontSize: 18, fontWeight: FontWeight.w400),
                prefixIcon: const Icon(Icons.villa_outlined, size: 33),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
           Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: telephone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Numero",
                hintStyle: GoogleFonts.aBeeZee(
                    fontSize: 18, fontWeight: FontWeight.w400),
                prefixIcon: const Icon(Icons.phone_android_outlined, size: 33),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MapsPage(getLatLng: getLatLng),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: Text("Valider",
                                style: GoogleFonts.roboto(
                                    fontSize: 20, color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Coordonnées géographiques",
                        style: GoogleFonts.roboto(
                            fontSize: 18, color: Colors.white)),
                    const SizedBox(width: 10),
                    const Icon(Icons.location_searching,
                        size: 28, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D1A30),
                minimumSize: const Size(400, 50),
              ),
              onPressed: () {
                sendOrders();
                 Navigator.pop(context);
              },
              child: Text("Passer commande",
                  style: GoogleFonts.roboto(fontSize: 20, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
