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
  const MyRecomadationWidget({super.key});

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
      height: 325,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recommandations",
                  style: GoogleFonts.roboto(
                      fontSize: AppSizes.fontLarge,
                      color: AppColor.textColor,
                      fontWeight: FontWeight.w600),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: AppSizes.iconMedium),
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
                  return const Text("Erreur lors du chargement des produits.");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("Aucun produit disponible.");
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
                          margin: const EdgeInsets.all(5),
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor.secondBackgroud,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Image.network(
                                    articles[index].img,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 15),
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
                                                fontSize: AppSizes.fontLarge,
                                                fontWeight: FontWeight.w600)),
                                        Text(
                                            "${articles[index].price.toString()} fcfa",
                                            style: GoogleFonts.roboto(
                                                fontSize: AppSizes.fontMedium,
                                                color: AppColor.accentColor)),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        favoriteProvider.addMyFavorites(
                                            articles[index]);
                                      },
                                      icon: favorites.firstWhereOrNull(
                                                  (item) =>
                                                      item.id ==
                                                      articles[index].id) ==
                                              null
                                          ? const Icon(
                                              Icons.favorite_border,
                                              size: 28,
                                              color: Color(0xff2c3e50),
                                            )
                                          : const Icon(
                                              Icons.favorite,
                                              size: 28,
                                              color: Colors.red,
                                            ),
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
