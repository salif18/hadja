import 'dart:async';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/product_admin_api.dart';
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
  final StreamController<List<ArticlesModel>> _articlesData =
      StreamController();
  ServicesAPiProducts api = ServicesAPiProducts();
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

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _getProducts();
  // }

  // fonction fetch data articles depuis server
  Future<void> _getProducts() async {
    try {
      final res = await api.getAllProducts();
      final body = jsonDecode(res.body);
      if(res.statusCode == 200){
      _articlesData.add(
        (body["articles"] as List).map((json)=> ArticlesModel.fromJson(json)).toList()
      );
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
                      fontSize: 22, fontWeight: FontWeight.w400),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 22)
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ArticlesModel>>(
                stream: _articlesData.stream,
                builder: (context, snaptshot) {
                  if (snaptshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snaptshot.hasError) {
                    return const Text("error");
                  } else if (!snaptshot.hasData || snaptshot.data!.isEmpty) {
                    return const Text("No data available");
                  } else {
                    final articles = snaptshot.data!;
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: articles.length,
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
                              margin: const EdgeInsets.all(5),
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFf0fcf3),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Image.network(
                                        articles[index].img,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
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
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text(
                                                "${articles[index].price.toString()} fcfa",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 18,
                                                    color: Colors.grey[500]))
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
                                                        articles[index]
                                                            .id,
                                                  ) ==
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
                        });
                  }
                }),
          )
        ],
      ),
    );
  }
}
