import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/models/orders_model.dart';
import 'package:hadja_grish/screens/client/single_order_client.dart';
import 'package:intl/intl.dart';

class CardOrderClient extends StatelessWidget {
  final OrdersModel order;
  const CardOrderClient({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> SingleOrderClient(order:order)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 180, 
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
                  Text("ORDER N°:${order.id.toString()}",style:GoogleFonts.roboto(fontSize:18,fontWeight: FontWeight.bold)),
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
                  Text("Date:",style: GoogleFonts.roboto(fontSize: 18,color:Colors.grey),),
                  Text(DateFormat('dd/MM/yyyy').format(order.createdAt),style: GoogleFonts.roboto(fontSize: 18),)
                ],
              ),
              Row( 
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ 
                  Text("Montant:",style: GoogleFonts.roboto(fontSize: 18,color:Colors.grey),),
                  Text(order.total.toString(),style: GoogleFonts.roboto(fontSize: 18),)
                ],
              ),
              
               Row( 
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ 
                  Text("Livrer:",style: GoogleFonts.roboto(fontSize: 18,color:Colors.grey),),
                  Text(order.statusOfDelibery,style: GoogleFonts.roboto(fontSize: 18 , fontWeight: FontWeight.bold, color: order.statusOfDelibery == "En attente" ? Colors.blue : Colors.green),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}