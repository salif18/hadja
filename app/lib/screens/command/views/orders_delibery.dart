import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/screens/command/widgets/card_order_delivery.dart';

class OrdersLivreurs extends StatefulWidget {
  const OrdersLivreurs({super.key});

  @override
  State<OrdersLivreurs> createState() => _OrdersLivreursState();
}

class _OrdersLivreursState extends State<OrdersLivreurs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
       appBar: AppBar(
            title: Text("Commandes",
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.w400)),
            centerTitle: true,
            toolbarHeight: 80,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24)),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: CardOrderDelivery(),
              ),
              
          ],
        ),
      ),
    );
  }
}