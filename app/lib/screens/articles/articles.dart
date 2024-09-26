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

class MyArticlePage extends StatefulWidget {
  const MyArticlePage({super.key});

  @override
  State<MyArticlePage> createState() => _MyArticlePageState();
}

class _MyArticlePageState extends State<MyArticlePage> {
  ServicesAPiProducts api = ServicesAPiProducts();

  // Fonction pour récupérer les articles depuis le serveur
  Future<List<ArticlesModel>> _getProducts() async {
    final res = await api.getAllProducts();
    final body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return (body["articles"] as List)
          .map((json) => ArticlesModel.fromJson(json))
          .toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    List<ArticlesModel> favorites = favoriteProvider.getFavorites;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        centerTitle: true,
        title: Text(
          "Articles",
          style: GoogleFonts.roboto(
              fontSize: AppSizes.fontLarge, fontWeight: FontWeight.w400),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nos produits",
                      style: GoogleFonts.roboto(
                          fontSize: AppSizes.fontLarge,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      "Tous",
                      style: GoogleFonts.roboto(
                          fontSize: AppSizes.fontLarge,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF55AB60)),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<ArticlesModel>>(
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
                    return GridView.builder(
                      itemCount: articles.length,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final article = articles[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleProductVerSionSliver(item: article),
                              ),
                            );
                          },
                          child: Container(
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
                                    height: 110,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Image.network(
                                      article.img,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15, top: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article.name,
                                            style: GoogleFonts.roboto(
                                                fontSize: MediaQuery.of(context).size.width*16/600,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            "${article.price} fcfa",
                                            style: GoogleFonts.roboto(
                                                fontSize: AppSizes.fontSmall,
                                                color: Colors.grey[500]),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          favoriteProvider.addMyFavorites(article);
                                        },
                                        icon: favorites.firstWhereOrNull(
                                                  (item) => item.id == article.id) ==
                                              null
                                          ? const Icon(
                                              Icons.favorite_border,
                                              size: AppSizes.iconLarge,
                                              color: Color(0xff2c3e50),
                                            )
                                          : const Icon(
                                              Icons.favorite,
                                              size: AppSizes.iconLarge,
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
            ],
          ),
        ),
      ),
    );
  }
}
