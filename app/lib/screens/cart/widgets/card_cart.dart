import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/cart_item_model.dart';
import 'package:hadja_grish/providers/cart_provider.dart';
import 'package:provider/provider.dart';


class MyCard extends StatefulWidget {
  final CartItemModel item;
  final constraints;

  const MyCard({super.key, required this.item,required this.constraints});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Container(
          width: widget.constraints.maxWidth,
          height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 100),
          padding:EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 80),
                width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 80),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                    image: DecorationImage(
                        image: NetworkImage(widget.item.img),
                        fit: BoxFit.fill)),
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
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                            fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                            color: const Color(0xff121212)),
                      ),
                      Text(widget.item.prix.toString(),
                          style: GoogleFonts.roboto(
                              fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                              color:const Color(0xff121212)))
                    ],
                  ),
                  Container(
                    height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 50),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D1A30),
                      borderRadius:BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                      border: Border.all(
                        color: const Color(0xFF1D1A30),
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 50),
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                            Provider.of<CartProvider>(context,listen:false).increment(widget.item);
                          }, 
                          child: Text("+",style:GoogleFonts.roboto(
                            color:Colors.white,
                            fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                            fontWeight: FontWeight.bold))),
                        ),
                        Container(
                          width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 50), 
                         alignment: Alignment.center,
                          child: Text(widget.item.qty.toString(),style:GoogleFonts.roboto(
                            color:Colors.white,
                            fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                            fontWeight: FontWeight.bold)),
                        ),
                       if(widget.item.qty >1) 
                       Container(
                        alignment: Alignment.center,
                        width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 50),
                         child: TextButton(onPressed: () {
                                Provider.of<CartProvider>(context, listen: false).decrement(widget.item);
                          }, 
                          child: Text("-",style:GoogleFonts.roboto(
                            color:Colors.white,
                            fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20),
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
