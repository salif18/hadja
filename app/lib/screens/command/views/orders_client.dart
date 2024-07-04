import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/screens/command/widgets/card_order_client.dart';

class OrdersClient extends StatefulWidget {
  const OrdersClient({super.key});

  @override
  State<OrdersClient> createState() => _OrdersClientState();
}

class _OrdersClientState extends State<OrdersClient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey[100], 
      appBar:AppBar(
        leading: IconButton(onPressed:(){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios_new_rounded, size:20)
        ),
         centerTitle: true, 
         title: Text("Commandes",style:GoogleFonts.roboto( 
          fontSize:24, 
          fontWeight:FontWeight.w400
         ),
         ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: CardOrderClient(),
              ),

          ],
        ),
      )
    );
  }
}