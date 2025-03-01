import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/orders_api.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/orders_model.dart';
import 'package:hadja_grish/screens/admin/card_orders_admin.dart';

class OrderAnnuler extends StatefulWidget {
  final constraints;
  const OrderAnnuler({super.key ,required this.constraints});

  @override
  State<OrderAnnuler> createState() => _OrderAnnulerState();
}

class _OrderAnnulerState extends State<OrderAnnuler> {
  ServicesApiOrders api = ServicesApiOrders();

  final StreamController<List<OrdersModel>> _ordersDataAnnuler =
      StreamController();

  @override
  void initState() {
    super.initState();
    _getOrdersAnnuler();
  }

  @override
  void dispose() {
    _ordersDataAnnuler.close();
    super.dispose();
  }

// fonction fetch data articles depuis server
  Future<void> _getOrdersAnnuler() async {
    try {
      final response = await api.getAllOrdersAnnuler();
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _ordersDataAnnuler.add(
          (body["orders"] as List)
              .map((json) => OrdersModel.fromJson(json))
              .toList(),
        );
      } else {
        _ordersDataAnnuler.addError("Failed to load orders");
      }
    } catch (e) {
      _ordersDataAnnuler.addError("Failed to load orders");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: StreamBuilder<List<OrdersModel>>(
            stream: _ordersDataAnnuler.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Problème de connexion au server",
                      style: GoogleFonts.roboto(
                          fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12), fontWeight: FontWeight.w600)),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text("Aucune donnée disponible",
                      style: GoogleFonts.roboto(
                          fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12), fontWeight: FontWeight.w600)),
                );
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final data = snapshot.data!;
                      OrdersModel order = data[index];
                      return CardOrderAdmin(order: order, constraints: widget.constraints,);
                    });
              }
            }));
  }
}
