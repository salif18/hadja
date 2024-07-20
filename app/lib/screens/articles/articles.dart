import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  Future<void> _getProducts() async {
    try {
      _articlesData.add(ArticlesModel.data());
    } catch (e) {
      _articlesData.addError(e);
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
        centerTitle: true,
        title: Text("Articles",
            style:
                GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w400)),
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
                        fontSize: 24, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "Tous",
                    style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF55AB60)),
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
                        return const CircularProgressIndicator();
                      } else if (snaptshot.hasError) {
                        return Text("err");
                      } else if (!snaptshot.hasData || snaptshot.data!.isEmpty) {
                        return Text("No data available");
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
                                  builder: (context) => SingleProductVerSionSliver(item: article[index])));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xfff0fcf3),
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
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Image.asset(
                                    article[index].img,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(article[index].name,
                                            style: GoogleFonts.roboto(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600)),
                                        Text(
                                            "${article[index].price.toString()} fcfa",
                                            style: GoogleFonts.roboto(
                                                fontSize: 18,
                                                color: Colors.grey[500])),
                                      ],
                                    ),
                                     IconButton(
                                          onPressed: () {
                                            favoriteProvider.addMyFavorites(
                                                article[index]);
                                          },
                                          icon: favorites.firstWhereOrNull(
                                                      (item) => item.productId
                                                          .contains(article[
                                                                  index]
                                                              .productId)) ==
                                                  null
                                              ? const Icon(
                                                  Icons.favorite_border,
                                                  size: 28,
                                                  color: Color(0xff2c3e50),
                                                )
                                              : const Icon(
                                                  Icons.favorite,
                                                  size: 28,
                                                  color: Colors.red)
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
                    }))
          ],
        ),
      )),
    );
  }
}
