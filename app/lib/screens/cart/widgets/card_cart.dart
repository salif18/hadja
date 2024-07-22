import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/models/cart_item_model.dart';
import 'package:hadja_grish/providers/cart_provider.dart';
import 'package:provider/provider.dart';


class MyCard extends StatefulWidget {
  final CartItemModel item;
  const MyCard({super.key, required this.item});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                        image: NetworkImage(widget.item.img),
                        fit: BoxFit.contain)),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.item.name,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                            fontSize: 20, 
                            color: const Color(0xff121212)),
                      ),
                      Text(widget.item.prix.toString(),
                          style: GoogleFonts.roboto(
                              fontSize: 18, 
                              color:const Color(0xff121212)))
                    ],
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1A30),
                      borderRadius:BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF1D1A30),
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                            Provider.of<CartProvider>(context,listen:false).increment(widget.item);
                          }, 
                          child: Text("+",style:GoogleFonts.roboto(
                            color:Colors.white,
                            fontSize:20,
                            fontWeight: FontWeight.bold))),
                        ),
                        Container(
                          width: 50, 
                         alignment: Alignment.center,
                          child: Text(widget.item.qty.toString(),style:GoogleFonts.roboto(
                            color:Colors.white,
                            fontSize:18,
                            fontWeight: FontWeight.bold)),
                        ),
                       if(widget.item.qty >1) 
                       Container(
                        alignment: Alignment.center,
                        width: 50,
                         child: TextButton(onPressed: () {
                                Provider.of<CartProvider>(context, listen: false).decrement(widget.item);
                          }, 
                          child: Text("-",style:GoogleFonts.roboto(
                            color:Colors.white,
                            fontSize:20,
                            fontWeight: FontWeight.bold))),
                       )
                      ],
                    ),
                  )
                ],
              ))
            ],
          )),
    );
  }
}
