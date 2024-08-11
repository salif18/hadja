import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/orders_api.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/orders_model.dart';
import 'package:hadja_grish/providers/auth_provider.dart';
import 'package:hadja_grish/screens/client/card_order_client.dart';
import 'package:provider/provider.dart';

class OrdersClient extends StatefulWidget {
  const OrdersClient({super.key});

  @override
  State<OrdersClient> createState() => _OrdersClientState();
}

class _OrdersClientState extends State<OrdersClient> {
  ServicesApiOrders api = ServicesApiOrders();
   final StreamController<List<OrdersModel>> _ordersData =
      StreamController();

  @override
  void initState() {
    super.initState();
    _getOrders();
  }

  @override
  void dispose() {
    _ordersData.close();
    super.dispose();
  }


// fonction fetch data articles depuis server
 Future<void> _getOrders() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    try {
      final response = await api.getUserOrders(userId);
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 ) {
        _ordersData.add(
          (body["orders"] as List)
              .map((json) => OrdersModel.fromJson(json))
              .toList(),
        );
      } else {
        _ordersData.addError("Failed to load orders");
      }
    } catch (e) {
      _ordersData.addError("Failed to load orders");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey[100], 
      appBar:AppBar(
        leading: IconButton(onPressed:(){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios_new_rounded, size:AppSizes.iconLarge)
        ),
         centerTitle: true, 
         title: Text("Commandes",style:GoogleFonts.roboto( 
          fontSize:AppSizes.fontLarge, 
          fontWeight:FontWeight.w400
         ),
         ),
      ),
      body: StreamBuilder<List<OrdersModel>>(
            stream: _ordersData.stream,
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
                      return CardOrderClient(order :order);
                    });
              }
            }),
    );
  }
}