// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hadja_grish/api/notification_api.dart';
import 'package:hadja_grish/api/orders_api.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/orders_model.dart';
import 'package:hadja_grish/providers/auth_provider.dart';
import 'package:hadja_grish/providers/cart_provider.dart';
import 'package:hadja_grish/screens/cart/widgets/maps.dart';
import 'package:provider/provider.dart';

class AddressLivraison extends StatefulWidget {
  final constraints;
  const AddressLivraison({super.key, required this.constraints});

  @override
  State<AddressLivraison> createState() => _AddressLivraisonState();
}

class _AddressLivraisonState extends State<AddressLivraison> {
  ServicesApiOrders api = ServicesApiOrders();
  final NotificationServices notiApi = NotificationServices();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController address = TextEditingController();
  final TextEditingController telephone = TextEditingController();
  // double lat = 12.652250;
  // double long = -7.981700;//ville
    //  double lat = 12.592990;
    //  double long = -8.065061;//sebenicoro
     double lat =12.585116;
     double long = -7.931593;//attbougou
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

  Future<void> sendOrders(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();

    if (userId == null) {
    api.showSnackBarErrorPersonalized(context, "Utilisateur non connecté");
    return;
  }

    final totalProvider = Provider.of<CartProvider>(context, listen: false);
    final total = totalProvider.calculateTotal();
    final cartprovider = Provider.of<CartProvider>(context, listen: false);
    final cart = cartprovider.myCart;

     if (cart.isEmpty) {
    api.showSnackBarErrorPersonalized(context, "Panier vide");
    return;
  }
   if (_formKey.currentState!.validate()) {
    try {

      final cartItems = cart.map((item) => {
      "productId": item.productId,
      "name": item.name,
      "img": item.img,
      "qty": item.qty,
      "prix": item.prix
    }).toList();

      Map<String, dynamic> order = {
        "userId": userId,
        "deliveryId": null,
        "address": address.text,
        "clientLat": lat,
        "clientLong": long,
        "deliveryLat":null,
        "deliveryLong":null,
        "telephone": telephone.text,
        "total": total,
        "statut_of_delibery": "En attente",
        "cartItems":cartItems   // jsonEncode(cart.map((item) => item.toJson()).toList()),
      };
      final response = await api.postOrders(order);
      final body = jsonDecode(response.body);
      print(order);
      if (response.statusCode == 201) {
        OrdersModel order = OrdersModel.fromJson(body["order"]);
        _sendNotification(order);
        cartprovider.clearCart();
        api.showSnackBarSuccessPersonalized(context, body["message"]);
      }else{
      api.showSnackBarErrorPersonalized(context, body["message"]);
      }
    } catch (e) {
      Exception(e);
    }
   }
  }


   Future<void> _sendNotification(order) async {
    final data = {
      'userId': "",
      'orderId': order.id,
      "username": "Hadja Store",
      'message': 'Vous avez une nouvelle commande',
    };
    try {
      await notiApi.postNotifications(data);
    
    } catch (e) {
      print("Erreur de connexion à l'API : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 560),
      width:  widget.constraints.maxWidth ,
      
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular( widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
        child: Container(
          padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
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
            padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Faites-vous livrer chez vous !",
                  style: GoogleFonts.abel(
                      fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20), fontWeight: FontWeight.bold),
                ),
                Text(
                  "Remplissez bien les renseignements",
                  style: GoogleFonts.abel(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14)),
                ),
              ],
            ),
          ),
          Container(
            height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 150),
            width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 100)),
              image: DecorationImage(
                image: AssetImage("assets/logos/delibery.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
            child: TextFormField(
              controller: address,
               validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez votre addresse';
                }
                return null;
              },
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Quartier",
                hintStyle: GoogleFonts.aBeeZee(
                    fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12), fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.villa_outlined, size: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
           Padding(
            padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
            child: TextFormField(
              controller: telephone,
               validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez votre numéro';
                }
                return null;
              },
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Numero",
                hintStyle: GoogleFonts.aBeeZee(
                    fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12), fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.phone_android_outlined, size: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 5), horizontal: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),
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
                                    fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12), color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 50),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
                  color: Colors.blue,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Coordonnées géographiques",
                        style: GoogleFonts.roboto(
                            fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12), color: Colors.white)),
                    SizedBox(width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
                    Icon(Icons.location_searching,
                        size: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20), color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D1A30),
                minimumSize: Size(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 400), widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 40)),
              ),
              onPressed: () {
                sendOrders(context);
                Navigator.pop(context);
              },
              child: Text("Passer commande",
                  style: GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12), color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
