import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/screens/maps/natives/delivery_track_client.dart';

class SingleOrderDelivery extends StatefulWidget {
  const SingleOrderDelivery({super.key});

  @override
  State<SingleOrderDelivery> createState() => _SingleOrderDeliveryState();
}

class _SingleOrderDeliveryState extends State<SingleOrderDelivery> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
      color: Colors.white,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 Image.asset("assets/images/prod1.jpeg",height: 80,width: 80,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Savon",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400)),
                    Text("Quantite 1",style:GoogleFonts.roboto(fontSize: 20,color:Colors.grey[500]))
                  ],
                ), 
                Text("prix: 234",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400))]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(), 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Huile",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400)),
                      Text("Quantite 1",style:GoogleFonts.roboto(fontSize: 20,color:Colors.grey[500]))
                    ],
                  ), 
                  Text("prix: 234",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400))]),
          ),
        ),
        const SizedBox(height: 100),
        Padding(padding: const EdgeInsets.all(15), 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400)),
            const SizedBox(width: 15),
            Text("12000 FCFA",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400))
          ],
        ),
        ),
        Padding(padding: const EdgeInsets.all(15), 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Payer",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400)),
            const SizedBox(width: 15),
            Text("oui",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400))
          ],
        )),
        Padding(padding: const EdgeInsets.all(15), 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Client",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400)),
            const SizedBox(width: 15),
            Text("Oumou",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400))
          ],
        )),
         Padding(padding: const EdgeInsets.all(15), 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Date",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400)),
            const SizedBox(width: 15),
            Text("12/06/2024",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400))
          ],
        )),
         Padding(padding: const EdgeInsets.all(15), 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Addresse",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400)),
            const SizedBox(width: 15),
            Text("Bamako,hamdalleye",style:GoogleFonts.roboto(fontSize: 20,fontWeight:FontWeight.w400))
          ],
        )),
        
        Padding(
          padding: const EdgeInsets.all(15),
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    (MaterialPageRoute(
                        builder: (context) => const DeliveryTrackingClient())));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:const Color(0xFF1D1A30),
                minimumSize: const Size(400,50),
                ),
              child: Text("Demarer la course",
                  style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white))),
        )
      ]),
    );
  }
}