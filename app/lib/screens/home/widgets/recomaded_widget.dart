import 'dart:async';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/product_admin_api.dart';
import 'package:hadja_grish/constants/app_color.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:hadja_grish/providers/favorite_provider.dart';
import 'package:hadja_grish/screens/home/details/single_product_sliver.dart';
import 'package:provider/provider.dart';

class MyRecomadationWidget extends StatefulWidget {
  final constraints;
  const MyRecomadationWidget({super.key, required this.constraints});

  @override
  State<MyRecomadationWidget> createState() => _MyRecomadationWidgetState();
}

class _MyRecomadationWidgetState extends State<MyRecomadationWidget> {
  ServicesAPiProducts api = ServicesAPiProducts();

  Future<List<ArticlesModel>> _getProducts() async {
    final res = await api.getAllProducts();
    final body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return (body["articles"] as List)
          .map((json) => ArticlesModel.fromJson(json))
          .take(5)
          .toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(
      context,
    );
    List<ArticlesModel> favorites = favoriteProvider.getFavorites;

    return SizedBox(
      height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 295),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20), vertical: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recommandations",
                  style: GoogleFonts.roboto(
                      fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                      color: AppColor.textColor,
                      fontWeight: FontWeight.w600),
                ),
               Icon(Icons.arrow_forward_ios_rounded,
                    size: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14)),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ArticlesModel>>(
              future: _getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Problème survenu lors du chargement des produits.",style: TextStyle(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12)),);
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text("Aucun produit disponible.",style: TextStyle(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12)),);
                } else {
                  final articles = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: articles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleProductVerSionSliver(
                                item: articles[index],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),
                          width: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 170),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
                            color: AppColor.secondBackgroud,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 160),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                                  ),
                                  child: Image.network(
                                    articles[index].img ?? "",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(
                                        left: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15), 
                                        top: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(articles[index].name,
                                            overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.roboto(
                                                
                                                    fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                                                    fontWeight: FontWeight.w600)),
                                            Text(
                                                "${articles[index].price.toString()} fcfa",
                                                style: GoogleFonts.roboto(
                                                    fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                                                    color: AppColor.accentColor)),
                                          ],
                                        ),
                                      ),
                                      // IconButton(
                                      //   onPressed: () {
                                      //     favoriteProvider.addMyFavorites(
                                      //         articles[index]);
                                      //   },
                                      //   icon: favorites.firstWhereOrNull(
                                      //               (item) =>
                                      //                   item.id ==
                                      //                   articles[index].id) ==
                                      //           null
                                      //       ? Icon(
                                      //           Icons.favorite_border,
                                      //           size: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 24),
                                      //           color: Color(0xff2c3e50),
                                      //         )
                                      //       : Icon(
                                      //           Icons.favorite,
                                      //           size: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 24),
                                      //           color: Colors.red,
                                      //         ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
