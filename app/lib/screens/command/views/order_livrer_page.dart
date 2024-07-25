import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/orders_api.dart';
import 'package:hadja_grish/models/orders_model.dart';
import 'package:hadja_grish/screens/command/widgets/card_orders_admin.dart';

class OrderLivrer extends StatefulWidget {
  const OrderLivrer({super.key});

  @override
  State<OrderLivrer> createState() => _OrderLivrerState();
}

class _OrderLivrerState extends State<OrderLivrer> {
  ServicesApiOrders api = ServicesApiOrders();

  final StreamController<List<OrdersModel>> _ordersDataLivrer =
      StreamController();

  @override
  void initState() {
    super.initState();
    _getOrdersLivrer();
  }

  @override
  void dispose() {
    _ordersDataLivrer.close();
    super.dispose();
  }

// fonction fetch data articles depuis server
  Future<void> _getOrdersLivrer() async {
    try {
      final response = await api.getAllOrdersLivrer();
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _ordersDataLivrer.add(
          (body["orders"] as List)
              .map((json) => OrdersModel.fromJson(json))
              .toList(),
        );
      } else {
        _ordersDataLivrer.addError("Failed to load orders");
      }
    } catch (e) {
      _ordersDataLivrer.addError("Failed to load orders");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: StreamBuilder<List<OrdersModel>>(
            stream: _ordersDataLivrer.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Erreur",
                      style: GoogleFonts.roboto(
                          fontSize: 20, fontWeight: FontWeight.w600)),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text("Aucune donnée disponible",
                      style: GoogleFonts.roboto(
                          fontSize: 20, fontWeight: FontWeight.w600)),
                );
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final data = snapshot.data!;
                      OrdersModel order = data[index];
                      return CardOrderAdmin(order: order);
                    });
              }
            }));
  }
}
