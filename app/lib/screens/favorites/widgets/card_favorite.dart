import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:hadja_grish/providers/favorite_provider.dart';
import 'package:provider/provider.dart';

class MyCardFavorites extends StatelessWidget {
  final ArticlesModel item;
  final constraints;
  const MyCardFavorites({super.key, required this.item, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
          width: constraints.maxWidth,
          height: constraints.maxWidth * AppSizes.converValueToadapter(context, 100),
          padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
              border: const Border(
                  bottom:
                      BorderSide(color: Color.fromARGB(255, 219, 219, 219)))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
                child: Container(
                  height: constraints.maxWidth * AppSizes.converValueToadapter(context, 80),
                  width: constraints.maxWidth * AppSizes.converValueToadapter(context, 80),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                      image: DecorationImage(
                          image: NetworkImage(item.img), fit: BoxFit.fill)),
                ),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                              color: const Color(0xFF1D1A30)),
                        ),
                        Text(item.price.toString(),
                            style: GoogleFonts.roboto(
                                fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12), color: const Color(0xFF1D1A30)))
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                         Provider.of<FavoriteProvider>(context,listen:false).removeToFavorite(item);
                      },
                      icon: Icon(Icons.favorite_rounded,color: Colors.red, size: constraints.maxWidth * AppSizes.converValueToadapter(context, 20)))
                ],
              ))
            ],
          )),
    );
  }
}
