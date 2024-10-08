import 'dart:async';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/product_admin_api.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:hadja_grish/providers/favorite_provider.dart';
import 'package:hadja_grish/screens/home/details/single_product_sliver.dart';
import 'package:provider/provider.dart';

class ArticleByCategories extends StatefulWidget {
  final dynamic categorie;
  const ArticleByCategories({super.key, required this.categorie});

  @override
  State<ArticleByCategories> createState() => _ArticleByCategoriesState();
}

class _ArticleByCategoriesState extends State<ArticleByCategories> {
  final StreamController<List<ArticlesModel>> _articlesData =
      StreamController();

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  @override
  void dispose() {
    _articlesData.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getProducts();
  }

  ServicesAPiProducts api = ServicesAPiProducts();

// fonction fetch data articles depuis server
  Future<void> _getProducts() async {
    try {
      final res = await api.getProductByCategorie(widget.categorie);
      final body = jsonDecode(res.body);
      if (res.statusCode == 200) {
        _articlesData.add((body["articles"] as List)
            .map((json) => ArticlesModel.fromJson(json))
            .toList());
      }
    } catch (e) {
      _articlesData.addError("");
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(
      context,
    );
    List<ArticlesModel> favorites = favoriteProvider.getFavorites;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(widget.categorie,
            style: GoogleFonts.roboto(
                fontSize: AppSizes.fontLarge, fontWeight: FontWeight.normal)),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined, size: AppSizes.iconMedium)),
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
                    "Nos ${widget.categorie}",
                    style: GoogleFonts.roboto(
                        fontSize: AppSizes.fontLarge, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            SizedBox(
                child: StreamBuilder<List<ArticlesModel>>(
                    stream: _articlesData.stream,
                    builder: (context, snaptshot) {
                      if (snaptshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snaptshot.hasError) {
                        return Center(
                            child: Text("err",
                                style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal)));
                      } else if (!snaptshot.hasData ||
                          snaptshot.data!.isEmpty) {
                        return Center(
                            child: Text(
                                "Pas de categories disponibles pour le moment",
                                style: GoogleFonts.roboto(
                                    fontSize: AppSizes.fontSmall,
                                    fontWeight: FontWeight.normal)));
                      } else {
                        return GridView.builder(
                            itemCount: snaptshot.data!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 0.8),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              final article = snaptshot.data!;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SingleProductVerSionSliver(
                                                  item: article[index])));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xfff0fcf3),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Image.network(
                                            article[index].img,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(article[index].name,
                                                    style: GoogleFonts.roboto(
                                                        fontSize: AppSizes.fontMedium,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                Text(
                                                    "${article[index].price.toString()} fcfa",
                                                    style: GoogleFonts.roboto(
                                                        fontSize: AppSizes.fontSmall,
                                                        color:
                                                            Colors.grey[500])),
                                              ],
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  favoriteProvider
                                                      .addMyFavorites(
                                                          article[index]);
                                                },
                                                icon: favorites.firstWhereOrNull(
                                                            (item) =>
                                                                item.id ==
                                                                article[index]
                                                                    .id) ==
                                                        null
                                                    ? const Icon(
                                                        Icons.favorite_border,
                                                        size: AppSizes.iconLarge,
                                                        color:
                                                            Color(0xff2c3e50),
                                                      )
                                                    : const Icon(Icons.favorite,
                                                        size: AppSizes.iconLarge,
                                                        color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    }))
          ],
        ),
      )),
    );
  }
}
