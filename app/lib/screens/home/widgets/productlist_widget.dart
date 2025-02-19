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
import 'package:hadja_grish/screens/articles/articles.dart';
import 'package:hadja_grish/screens/home/details/single_product_sliver.dart';
import 'package:provider/provider.dart';

class MyProductListWidget extends StatefulWidget {
  final constraints;
  const MyProductListWidget({super.key, required this.constraints});

  @override
  State<MyProductListWidget> createState() => _MyProductListWidgetState();
}

class _MyProductListWidgetState extends State<MyProductListWidget> {
  ServicesAPiProducts api = ServicesAPiProducts();

  Future<List<ArticlesModel>> _getProducts() async {
    final res = await api.getAllProducts();
    final body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return (body["articles"] as List)
          .map((json) => ArticlesModel.fromJson(json)).take(10)
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

    return Padding(
      padding: EdgeInsets.all(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Nos produits",
                  style: GoogleFonts.roboto(
                      fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                      color: AppColor.textColor,
                      fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyArticlePage()));
                  },
                  child: Text(
                    "Explorer tous",
                    style: GoogleFonts.roboto(
                        fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[400]),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            child: FutureBuilder<List<ArticlesModel>>(
              future: _getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Problème lors du chargement des produits.",style: TextStyle(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12)),);
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text("Aucun produit disponible.",style: TextStyle(fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12)),);
                } else {
                  final articles = snapshot.data!;
                  return GridView.builder(
                    itemCount: articles.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 0.8,
                    ),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SingleProductVerSionSliver(
                                          item: articles[index])));
                        },
                        child: Container(
                          width: widget.constraints.maxWidth,
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
                                  width: widget.constraints.maxWidth ,
                                  height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 110),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                                  ),
                                  child: Image.network(
                                    articles[index].img,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15), top: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(articles[index].name,
                                            style: GoogleFonts.roboto(
                                                fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                                                fontWeight: FontWeight.w600)),
                                        Text(
                                            "${articles[index].price.toString()} fcfa",
                                            style: GoogleFonts.roboto(
                                                fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                                                color: AppColor.accentColor)),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        favoriteProvider.addMyFavorites(
                                            articles[index]);
                                      },
                                      icon: favorites.firstWhereOrNull((item) =>
                                                  item.id ==
                                                  articles[index].id) ==
                                              null
                                          ? Icon(
                                              Icons.favorite_border,
                                              size: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 24),
                                              color: Color(0xff2c3e50),
                                            )
                                          : Icon(
                                              Icons.favorite,
                                              size: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 24),
                                              color: Colors.red),
                                    ),
                                  ],
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
