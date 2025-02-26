import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/orders_api.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/orders_model.dart';
import 'package:hadja_grish/screens/livreur/delivery_track_client.dart';
import 'package:intl/intl.dart';

class SingleOrderDeliveryNotification extends StatefulWidget {
  final String orderId;
  final constraints;
  const SingleOrderDeliveryNotification({super.key,required this.orderId, required this.constraints});

  @override
  State<SingleOrderDeliveryNotification> createState() => _SingleOrderDeliveryNotificationState();
}

class _SingleOrderDeliveryNotificationState extends State<SingleOrderDeliveryNotification> {

   ServicesApiOrders api = ServicesApiOrders();
  OrdersModel? order;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _getOrders();
  }

  Future<void> _getOrders() async {
    try {
      final response = await api.getOneOrder(widget.orderId);
      if (response.statusCode == 200) {
        setState(() {
          order = OrdersModel.fromJson(jsonDecode(response.body)["order"]);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Erreur de chargement";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Erreur réseau";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Scaffold(body: Center(child: CircularProgressIndicator()));
    if (errorMessage != null) return Scaffold(body: Center(child: Text(errorMessage!)));
    if (order == null) return Scaffold(body: Center(child: Text("Commande introuvable")));
    return  Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text("Details",
            style:
                GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 16), fontWeight: FontWeight.w400)),
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
      padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
      child: Column(
        children: [
         SizedBox(
        height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 400),
         child: ListView.builder(
          itemCount: order?.orderItems.length ,
          itemBuilder: (BuildContext context, int index){
            final item =order?.orderItems[index];
            return  Padding(
            padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
            child: Container(
              height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 100),
              padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Image.network(item?.img ?? "",height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 80),width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 80),), 
                   SizedBox(width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item?.name ?? "",overflow: TextOverflow.ellipsis,style:GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),fontWeight:FontWeight.w400)),
                          Text("Quantité ${item?.qty.toString()}",style:GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),color:Colors.grey[500]))
                        ],
                      ),
                    ), 
                    Text("prix ${item?.prix}",style:GoogleFonts.roboto(fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),fontWeight:FontWeight.w400))]),
            ),
          );
          }
         ),
       ),
        Padding(padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)), 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total",style:GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),fontWeight:FontWeight.w400)),
            const SizedBox(width: 15),
            Text("${order?.total} FCFA",style:GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),fontWeight:FontWeight.w400))
          ],
        ),
        ),
        Padding(padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)), 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Order",style:GoogleFonts.roboto(fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),fontWeight:FontWeight.w400)),
            const SizedBox(width: 15),
            Text(order!.statusOfDelibery ,style:GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),fontWeight:FontWeight.w400))
          ],
        )),
        Padding(padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)), 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Client",style:GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),fontWeight:FontWeight.w400)),
            SizedBox(width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
            Text(order!.telephone,style:GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),fontWeight:FontWeight.w400))
          ],
        )),
         Padding(padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)), 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Date",style:GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),fontWeight:FontWeight.w400)),
            SizedBox(width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
            Text(DateFormat('dd/MM/yyyy').format(order!.createdAt),style:GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),fontWeight:FontWeight.w400))
          ],
        )),
         Padding(padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)), 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Addresse",style:GoogleFonts.roboto(fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),fontWeight:FontWeight.w400)),
            SizedBox(width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
            Text(order!.address,style:GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),fontWeight:FontWeight.w400))
          ],
        )),
        Padding(
          padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    (MaterialPageRoute(
                        builder: (context) =>  DeliveryTrackingClient(order: order!,constraints:widget.constraints))));
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 400),widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 40)),
                backgroundColor: const Color(0xFF1D1A30),),
              child: Text("Suivis du courier",
                  style: GoogleFonts.roboto(
                      fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                      fontWeight: FontWeight.w400,
                      color: Colors.white))),
        )
      ]),
    );
  }
}