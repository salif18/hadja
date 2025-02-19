import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/orders_model.dart';
import 'package:hadja_grish/screens/client/client_track_delivery.dart';
import 'package:intl/intl.dart';

class SingleOrderClient extends StatefulWidget {
  final OrdersModel order;
  final constraints;
  const SingleOrderClient({super.key, required this.order, required this.constraints});

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
      padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
      decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20))
      ),
      child: Column(
        children: [
      
       SizedBox(
        height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 400),
         child: ListView.builder(
          itemCount: widget.order.orderItems.length,
          itemBuilder: (BuildContext context, int index){
            final item =widget.order.orderItems[index];
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
                     Image.network(item.img,height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 80),width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 80),), 
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name,style:GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),fontWeight:FontWeight.w400)),
                        Text("Quantité ${item.qty.toString()}",style:GoogleFonts.roboto(fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),color:Colors.grey[500]))
                      ],
                    ), 
                    Text("prix ${item.prix}",style:GoogleFonts.roboto(fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),fontWeight:FontWeight.w400))]),
            ),
          );
          }
         ),
       ),
        Padding(padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)), 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total",style:GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),fontWeight:FontWeight.w400)),
            SizedBox(width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
            Text("${widget.order.total} FCFA",style:GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),fontWeight:FontWeight.w400))
          ],
        ),
        ),
       
        Padding(padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)), 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Livreur",style:GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),fontWeight:FontWeight.w400)),
            SizedBox(width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
            Text(widget.order.deliveryId.toString(),style:GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),fontWeight:FontWeight.w400))
          ],
        )),
         Padding(padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)), 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Date",style:GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),fontWeight:FontWeight.w400)),
            SizedBox(width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
            Text(DateFormat('dd/MM/yyyy').format(widget.order.createdAt),style:GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),fontWeight:FontWeight.w400))
          ],
        )),
         Padding(padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)), 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Livrer",style:GoogleFonts.roboto(fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),fontWeight:FontWeight.w400)),
            SizedBox(width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
            Text(widget.order.statusOfDelibery,style:GoogleFonts.roboto(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),fontWeight:FontWeight.w400))
          ],
        )),
        
        Padding(
          padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    (MaterialPageRoute(
                        builder: (context) => ClientTrackingDelivery(order:widget.order,constraints:widget.constraints))));
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 400),widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 40)),
                backgroundColor: const Color(0xFF1D1A30),),
              child: Text("Suis le livreur",
                  style: GoogleFonts.roboto(
                      fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                      fontWeight: FontWeight.w400,
                      color: Colors.white))),
        )
      ]),
    );
  }
}