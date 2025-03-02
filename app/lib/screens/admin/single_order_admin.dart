// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/auth_api.dart';
import 'package:hadja_grish/api/livreurs_api.dart';
import 'package:hadja_grish/api/notification_api.dart';
import 'package:hadja_grish/api/orders_api.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/orders_model.dart';
import 'package:hadja_grish/models/user.dart';
import 'package:hadja_grish/screens/admin/admin_track_move.dart';
import 'package:intl/intl.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

class SingleOrder extends StatefulWidget {
  final OrdersModel order;
  final constraints;
  const SingleOrder(
      {super.key, required this.order, required this.constraints});

  @override
  State<SingleOrder> createState() => _SingleOrderState();
}

class _SingleOrderState extends State<SingleOrder> {
  // FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? deliveryId;
  // late IO.Socket socket;
// Déclarez socket comme nullable
final ServicesApiAuth apiAuth = ServicesApiAuth();
  final ServicesApiOrders api = ServicesApiOrders();
  final NotificationServices notiApi = NotificationServices();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final ServicesApiDelibery apiDelibery = ServicesApiDelibery();

  List<ProfilModel> _liberyData = [];


  @override
  void initState() {
    super.initState();
    // getTokenFCM();
    // socket = IO.io(
    //     "http://10.0.2.2:8080",
    //     IO.OptionBuilder().setTransports(["websocket"]).setQuery(
    //         {"userId": deliveryId}).build());
    _getLibery().then((_) {
      if (_liberyData.isNotEmpty) {
        deliveryId = _liberyData.first.userId; // Initialisez deliveryId
        // _connectToSocket();
      }
    });
  }

//   Future<void> getTokenFCM() async {
//   String? token = await FirebaseMessaging.instance.getToken();
//   print("FCM Token: $token");
//   if (token == null) {
//   print("Erreur : Token Firebase est null !");
//   return;
// }
//   try{
//     final res = await apiAuth.postTokenFmcUser(token);
//     final body = jsonDecode(res.body);
//     if(res.statusCode == 200){
//       print(body["message"]);
//     }
//   }catch(e){
//     print("erreur $e");
//   }
// }

  // void _connectToSocket() {
  //   if (deliveryId == null || deliveryId!.isEmpty) {
  //     print("Erreur : deliveryId est null ou vide !");
  //     return;
  //   }

  //   socket.onConnect((_) {
  //     print('Connecté au serveur WebSocket');
  //     socket.emit('join-room', deliveryId);
  //   });

  //   socket.onDisconnect((_) {
  //     print("Déconnecté du WebSocket");
  //   });

  //   socket.onConnectError((err) {
  //     print('Erreur de connexion WebSocket: $err');
  //   });

  //   socket.onError((err) {
  //     print('Erreur WebSocket: $err');
  //   });

  //   // socket.connect();
  // }

  Future<void> _getLibery() async {
    try {
      final res = await apiDelibery.getAllDelibery();
      if (res.statusCode == 200) {
        final body = json.decode(res.body);
        setState(() {
          _liberyData = (body["theLiberys"] as List)
              .map((json) => ProfilModel.fromJson(json))
              .toList();
        });
      } else {
        throw Exception('Failed to load libery');
      }
    } catch (e) {
      print('Error fetching libery: $e');
    }
  }

  Future<void> _sendToServer(BuildContext context) async {
    final data = {
      "deliveryId": deliveryId,
    };
    try {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      final response = await api.postLiveryIdToOrders(data, widget.order.id);
      final body = jsonDecode(response.body);
      Navigator.pop(context); // Close the dialog

      if (response.statusCode == 201) {
        _sendNotification(deliveryId);
        api.showSnackBarSuccessPersonalized(context, body["message"]);
      } else {
        api.showSnackBarErrorPersonalized(context, body["message"]);
      }
    } catch (e) {
      Navigator.pop(context); // Close the dialog
      api.showSnackBarErrorPersonalized(context, e.toString());
    }
  }

  Future<void> _sendNotification(String? deliveryId) async {
    if (deliveryId == null) {
      print("Erreur : deliveryId ou socket est null !");
      return;
    }
    final livreur = _liberyData.firstWhere((e) => e.userId == deliveryId);
    
    final data = {
      'receiverId': deliveryId,
      'orderId': widget.order.id,
      "username": livreur.name,
      'message': 'Vous avez une nouvelle commande à livrer',
    };

    try {
      final response = await notiApi.postNotifications(data);
      if (response.statusCode == 201) {
      
        // socket.emit('post-livreur', {
        //   'userId': deliveryId,
        //   'orderId': widget.order.id,
        //   "username": livreur.name,
        //   'message': data['message'],
        // });
      } else {
        print("Erreur lors de l'envoi de la notification : ${response.body}");
      }
    } catch (e) {
      print("Erreur de connexion à l'API : $e");
    }
  }

  // @override
  // void dispose() {
  //   socket.disconnect();
  //   socket.clearListeners();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text("Details",
            style: GoogleFonts.roboto(
                fontSize: widget.constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 16),
                fontWeight: FontWeight.w400)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [_orders(context)],
        ),
      ),
    );
  }

  Widget _orders(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(widget.constraints.maxWidth *
          AppSizes.converValueToadapter(context, 15)),
      child: Column(
        children: [
          SizedBox(
            height: widget.constraints.maxWidth *
                AppSizes.converValueToadapter(context, 360),
            child: ListView.builder(
              itemCount: widget.order.orderItems.length,
              itemBuilder: (BuildContext context, int index) {
                final item = widget.order.orderItems[index];
                return Padding(
                  padding: EdgeInsets.all(widget.constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 8)),
                  child: Container(
                    height: widget.constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 100),
                    padding: EdgeInsets.all(widget.constraints.maxWidth *
                        AppSizes.converValueToadapter(context, 8)),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            widget.constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 20))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(item.img ?? "",
                            height: widget.constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 80),
                            width: widget.constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 80)),
                        SizedBox(
                            width: widget.constraints.maxWidth *
                                AppSizes.converValueToadapter(context, 8)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                      fontSize: widget.constraints.maxWidth *
                                          AppSizes.converValueToadapter(
                                              context, 12),
                                      fontWeight: FontWeight.w400)),
                              Text("Quantité ${item.qty}",
                                  style: GoogleFonts.roboto(
                                      fontSize: widget.constraints.maxWidth *
                                          AppSizes.converValueToadapter(
                                              context, 12),
                                      color: Colors.grey[500])),
                            ],
                          ),
                        ),
                        Text("prix ${item.prix}",
                            style: GoogleFonts.roboto(
                                fontSize: widget.constraints.maxWidth *
                                    AppSizes.converValueToadapter(context, 12),
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.order.deliveryId == null)
            Padding(
              padding: EdgeInsets.all(1),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Form(
                        key: _globalKey,
                        child: Padding(
                          padding: EdgeInsets.all(widget.constraints.maxWidth *
                              AppSizes.converValueToadapter(context, 10)),
                          child: DropdownButtonFormField<String?>(
                            hint: Text(
                              "Choisir un livreur",
                              style: GoogleFonts.roboto(
                                  fontSize: widget.constraints.maxWidth *
                                      AppSizes.converValueToadapter(
                                          context, 14),
                                  fontWeight: FontWeight.w500),
                            ),
                            value: deliveryId,
                            onChanged: (value) {
                              setState(() {
                                deliveryId = value;
                              });
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.grey[100],
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(widget
                                        .constraints.maxWidth *
                                    AppSizes.converValueToadapter(context, 20)),
                              ),
                            ),
                            items: _liberyData.map((delivery) {
                              return DropdownMenuItem<String?>(
                                value: delivery.userId.toString(),
                                child: Text(
                                  delivery.name ?? "",
                                  style: GoogleFonts.roboto(
                                      fontSize: widget.constraints.maxWidth *
                                          AppSizes.converValueToadapter(
                                              context, 12),
                                      color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D1A30)),
                        onPressed: () {
                          _sendToServer(context);
                        },
                        child: Text(
                          "Confirmer",
                          style: GoogleFonts.roboto(
                              fontSize: widget.constraints.maxWidth *
                                  AppSizes.converValueToadapter(context, 12),
                              color: Colors.white),
                        ))
                  ],
                ),
              ),
            ),
          Column(
            children: [
              _orderDetailRow("Order", widget.order.statusOfDelibery),
              _orderDetailRow("Client", widget.order.telephone),
              _orderDetailRow("Date",
                  DateFormat('dd/MM/yyyy').format(widget.order.createdAt)),
              _orderDetailRow("Adresse", widget.order.address),
              Padding(
                padding: EdgeInsets.all(widget.constraints.maxWidth *
                    AppSizes.converValueToadapter(context, 15)),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminTrackingDelivery(
                                  order: widget.order,
                                )));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                        widget.constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 400),
                        widget.constraints.maxWidth *
                            AppSizes.converValueToadapter(context, 40)),
                    backgroundColor: const Color(0xFF1D1A30),
                  ),
                  child: Text("Suivi du courrier",
                      style: GoogleFonts.roboto(
                          fontSize: widget.constraints.maxWidth *
                              AppSizes.converValueToadapter(context, 12),
                          fontWeight: FontWeight.w400,
                          color: Colors.white)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _orderDetailRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.all(widget.constraints.maxWidth *
          AppSizes.converValueToadapter(context, 15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: GoogleFonts.roboto(
                  fontSize: widget.constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 12),
                  fontWeight: FontWeight.w400)),
          SizedBox(
              width: widget.constraints.maxWidth *
                  AppSizes.converValueToadapter(context, 15)),
          Text(value,
              style: GoogleFonts.roboto(
                  fontSize: widget.constraints.maxWidth *
                      AppSizes.converValueToadapter(context, 12),
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
