import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/screens/command/detail/single_order_client.dart';

class CardOrderClient extends StatelessWidget {
  const CardOrderClient({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const SingleOrderClient()));
      },
      child: Container(
        height: 220, 
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
              child: Text("Commande N01",style:GoogleFonts.roboto(fontSize:24,fontWeight: FontWeight.bold)),
            ),
            Divider(
              height: 2,
              color: Colors.grey[100],
            ),
             Row( 
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ 
                Text("Date:",style: GoogleFonts.roboto(fontSize: 18,color:Colors.grey),),
                Text("12/03/2024",style: GoogleFonts.roboto(fontSize: 18),)
              ],
            ),
            Row( 
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ 
                Text("Montant:",style: GoogleFonts.roboto(fontSize: 18,color:Colors.grey),),
                Text("10.000 f",style: GoogleFonts.roboto(fontSize: 18),)
              ],
            ),
             Row( 
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ 
                Text("Payer:",style: GoogleFonts.roboto(fontSize: 18,color:Colors.grey),),
                Text("Oui",style: GoogleFonts.roboto(fontSize: 18),)
              ],
            ),
             Row( 
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ 
                Text("Livrer:",style: GoogleFonts.roboto(fontSize: 18,color:Colors.grey),),
                Text("Non",style: GoogleFonts.roboto(fontSize: 18),)
              ],
            )
          ],
        ),
      ),
    );
  }
}