import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/orders_api.dart';
import 'package:hadja_grish/models/orders_model.dart';
import 'package:hadja_grish/providers/auth_provider.dart';
import 'package:hadja_grish/screens/livreur/card_order_delivery.dart';
import 'package:provider/provider.dart';

class ListOrderLivrer extends StatefulWidget {
  const ListOrderLivrer({super.key});

  @override
  State<ListOrderLivrer> createState() => _ListOrderLivrerState();
}

class _ListOrderLivrerState extends State<ListOrderLivrer> {
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
      final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    try {
      final response = await api.getDeliveryOrdersLivery(userId);
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
       appBar: AppBar(
            title: Text("Mes livraisons",
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.w400)),
            centerTitle: true,
            toolbarHeight: 80,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24)),
       ),
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
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CardOrderDelivery(order: order),
                      );
                    });
              }
            }));
  }
}