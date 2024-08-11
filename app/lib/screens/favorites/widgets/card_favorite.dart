import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:hadja_grish/providers/favorite_provider.dart';
import 'package:provider/provider.dart';

class MyCardFavorites extends StatelessWidget {
  final ArticlesModel item;
  const MyCardFavorites({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: const Border(
                  bottom:
                      BorderSide(color: Color.fromARGB(255, 219, 219, 219)))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: NetworkImage(item.img), fit: BoxFit.contain)),
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
                              fontSize: AppSizes.fontMedium,
                              color: const Color(0xFF1D1A30)),
                        ),
                        Text(item.price.toString(),
                            style: GoogleFonts.roboto(
                                fontSize: AppSizes.fontSmall, color: const Color(0xFF1D1A30)))
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                         Provider.of<FavoriteProvider>(context,listen:false).removeToFavorite(item);
                      },
                      icon: const Icon(Icons.favorite_rounded,color: Colors.red, size: AppSizes.iconLarge))
                ],
              ))
            ],
          )),
    );
  }
}
