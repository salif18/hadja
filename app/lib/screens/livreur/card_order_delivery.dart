import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/orders_model.dart';
import 'package:hadja_grish/screens/livreur/single_order_delivery.dart';
import 'package:intl/intl.dart';

class CardOrderDelivery extends StatelessWidget {
  final OrdersModel order;
  final constraints;
  const CardOrderDelivery({super.key, required this.order, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> SingleOrderDelivery(order:order,constraints:constraints)));
      },
      child: Padding(
        padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
        child: Container(
          height: constraints.maxWidth * AppSizes.converValueToadapter(context, 190),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 20))
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("ORDER N° ${order.id}",style:GoogleFonts.roboto(fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context, 14),fontWeight: FontWeight.bold)),
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
                  Text("Date:",style: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14),color:Colors.grey),),
                  Text(DateFormat('dd/MM/yyyy').format(order.createdAt),style: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12)),)
                ],
              ),
              Row( 
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ 
                  Text("Client:",style: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14),color:Colors.grey),),
                  Text(order.telephone,style: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12)),)
                ],
              ),
               Row( 
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ 
                  Text("Address:",style: GoogleFonts.roboto(fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context, 14),color:Colors.grey),),
                  Text(order.address,style: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12)),)
                ],
              ),
               
               Row( 
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ 
                  Text("Order:",style: GoogleFonts.roboto(fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context, 14),color:Colors.grey),),
                  Text(order.statusOfDelibery,style: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12) , fontWeight: FontWeight.bold, color: order.statusOfDelibery == "En attente" ? Colors.blue : Colors.green),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}