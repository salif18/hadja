import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/models/orders_model.dart';
import 'package:hadja_grish/screens/livreur/single_order_delivery.dart';
import 'package:intl/intl.dart';

class CardOrderDelivery extends StatelessWidget {
  final OrdersModel order;
  const CardOrderDelivery({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> SingleOrderDelivery(order:order)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 190,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("ORDER N° ${order.id}",style:GoogleFonts.roboto(fontSize:16,fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Divider(
                height: 2,
                color: Colors.grey[100],
              ),
               Row( 
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ 
                  Text("Date:",style: GoogleFonts.roboto(fontSize: 14,color:Colors.grey),),
                  Text(DateFormat('dd/MM/yyyy').format(order.createdAt),style: GoogleFonts.roboto(fontSize: 14),)
                ],
              ),
              Row( 
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ 
                  Text("Client:",style: GoogleFonts.roboto(fontSize: 14,color:Colors.grey),),
                  Text(order.telephone,style: GoogleFonts.roboto(fontSize: 14),)
                ],
              ),
               Row( 
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ 
                  Text("Address:",style: GoogleFonts.roboto(fontSize: 14,color:Colors.grey),),
                  Text(order.address,style: GoogleFonts.roboto(fontSize: 14),)
                ],
              ),
               
               Row( 
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ 
                  Text("Order:",style: GoogleFonts.roboto(fontSize: 14,color:Colors.grey),),
                  Text(order.statusOfDelibery,style: GoogleFonts.roboto(fontSize: 14 , fontWeight: FontWeight.bold, color: order.statusOfDelibery == "En attente" ? Colors.blue : Colors.green),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}