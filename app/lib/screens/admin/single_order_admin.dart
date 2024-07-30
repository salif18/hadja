// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/livreurs_api.dart';
import 'package:hadja_grish/api/orders_api.dart';
import 'package:hadja_grish/models/orders_model.dart';
import 'package:hadja_grish/models/user.dart';
import 'package:hadja_grish/screens/admin/admin_track_move.dart';
import 'package:intl/intl.dart';

class SingleOrder extends StatefulWidget {
  final OrdersModel order;
  const SingleOrder({super.key, required this.order});

  @override
  State<SingleOrder> createState() => _SingleOrderState();
}

class _SingleOrderState extends State<SingleOrder> {
  final ServicesApiOrders api = ServicesApiOrders();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final ServicesApiDelibery apiDelibery = ServicesApiDelibery();

  List<ProfilModel> _liberyData = [];
  String? deliveryId;

  @override
  void initState() {
    super.initState();
    _getLibery();
  }

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

      if (response.statusCode == 200) {
        api.showSnackBarSuccessPersonalized(context, body["message"]);
      } else {
        api.showSnackBarErrorPersonalized(context, body["message"]);
      }
    } catch (e) {
      Navigator.pop(context); // Close the dialog
      api.showSnackBarErrorPersonalized(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text("Details",
            style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400)),
      ),
      body: Column(
          children: [_orders(context)],
      ),
    );
  }

  Widget _orders(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          SizedBox(
            height: 360,
            child: ListView.builder(
              itemCount: widget.order.orderItems.length,
              itemBuilder: (BuildContext context, int index) {
                final item = widget.order.orderItems[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.network(item.img, height: 80, width: 80),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                style: GoogleFonts.roboto(
                                    fontSize: 20, fontWeight: FontWeight.w400)),
                            Text("Quantité ${item.qty}",
                                style: GoogleFonts.roboto(
                                    fontSize: 20, color: Colors.grey[500])),
                          ],
                        ),
                        Text("prix ${item.prix}",
                            style: GoogleFonts.roboto(
                                fontSize: 20, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.order.deliveryId == null)
            Padding(
              padding: const EdgeInsets.all(1),
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Form(
                        key: _globalKey,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: DropdownButtonFormField<String?>(
                            hint: Text(
                              "Choisir un livreur",
                              style: GoogleFonts.roboto(
                                  fontSize: 20, fontWeight: FontWeight.w500),
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
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            items: _liberyData.map((delivery) {
                              return DropdownMenuItem<String?>(
                                value: delivery.userId.toString(),
                                child: Text(
                                  delivery.name!,
                                  style: GoogleFonts.roboto(
                                      fontSize: 20, color: Colors.black),
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
                              fontSize: 18, color: Colors.white),
                        ))
                  ],
                ),
              ),
            ),
          _orderDetailRow("Order", widget.order.statusOfDelibery),
          _orderDetailRow("Client", widget.order.telephone),
          _orderDetailRow("Date", DateFormat('dd/MM/yyyy').format(widget.order.createdAt)),
          _orderDetailRow("Adresse", widget.order.address),
          Padding(
            padding: const EdgeInsets.all(15),
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
                minimumSize: const Size(400, 50),
                backgroundColor: const Color(0xFF1D1A30),
              ),
              child: Text("Suivi du courrier",
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: GoogleFonts.roboto(
                  fontSize: 20, fontWeight: FontWeight.w400)),
          const SizedBox(width: 15),
          Text(value,
              style: GoogleFonts.roboto(
                  fontSize: 20, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
