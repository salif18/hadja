import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/models/orders_model.dart';
import 'package:hadja_grish/screens/client/client_track_delivery.dart';
import 'package:intl/intl.dart';

class SingleOrderClient extends StatefulWidget {
  final OrdersModel order;
  const SingleOrderClient({super.key, required this.order});

  @override
  State<SingleOrderClient> createState() => _SingleOrderClientState();
}

class _SingleOrderClientState extends State<SingleOrderClient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text("Details",
            style:
                GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400)),
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
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        children: [
      
       SizedBox(
        height: 400,
         child: ListView.builder(
          itemCount: widget.order.orderItems.length,
          itemBuilder: (BuildContext context, int index){
            final item =widget.order.orderItems[index];
            return  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Image.network(item.img,height: 80,width: 80,), 
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name,style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400)),
                        Text("Quantité ${item.qty.toString()}",style:GoogleFonts.roboto(fontSize: 20,color:Colors.grey[500]))
                      ],
                    ), 
                    Text("prix ${item.prix}",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400))]),
            ),
          );
          }
         ),
       ),
        Padding(padding: const EdgeInsets.all(15), 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400)),
            const SizedBox(width: 15),
            Text("${widget.order.total} FCFA",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400))
          ],
        ),
        ),
       
        Padding(padding: const EdgeInsets.all(15), 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Livreur",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400)),
            const SizedBox(width: 15),
            Text(widget.order.deliveryId.toString(),style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400))
          ],
        )),
         Padding(padding: const EdgeInsets.all(15), 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Date",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400)),
            const SizedBox(width: 15),
            Text(DateFormat('dd/MM/yyyy').format(widget.order.createdAt),style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400))
          ],
        )),
         Padding(padding: const EdgeInsets.all(15), 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Livrer",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400)),
            const SizedBox(width: 15),
            Text(widget.order.statusOfDelibery,style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400))
          ],
        )),
        
        Padding(
          padding: const EdgeInsets.all(15),
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    (MaterialPageRoute(
                        builder: (context) => const ClientTrackingDelivery())));
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(400,50),
                backgroundColor: const Color(0xFF1D1A30),),
              child: Text("Suis le livreur",
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white))),
        )
      ]),
    );
  }
}