import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:hadja_grish/providers/favorite_provider.dart';
import 'package:hadja_grish/screens/articles/articles.dart';
import 'package:hadja_grish/screens/home/details/single_product_sliver.dart';
import 'package:provider/provider.dart';

class MyProductListWidget extends StatefulWidget {
  const MyProductListWidget({super.key});

  @override
  State<MyProductListWidget> createState() => _MyProductListWidgetState();
}

class _MyProductListWidgetState extends State<MyProductListWidget> {
  final StreamController<List<ArticlesModel>> _articlesData = StreamController();

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
void didChangeDependencies(){
  super.didChangeDependencies();
  _getProducts();
}

  Future<void> _getProducts() async {
    try {
      _articlesData.add(ArticlesModel.data());
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
    return Padding(
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
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[400]),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            child: StreamBuilder<List<ArticlesModel>>(
              stream: _articlesData.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Text("Error");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No data available");
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
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SingleProductVerSionSliver(item: articles[index])));
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
                                    articles[index].img,
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
                                        Text(articles[index].name,
                                            style: GoogleFonts.roboto(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600)),
                                        Text(
                                            "${articles[index].price.toString()} fcfa",
                                            style: GoogleFonts.roboto(
                                                fontSize: 18,
                                                color: Colors.grey[500])),
                                      ],
                                    ),
                                     IconButton(
                                          onPressed: () {
                                            favoriteProvider.addMyFavorites(
                                                articles[index]);
                                          },
                                          icon: favorites.firstWhereOrNull(
                                                      (item) => item.productId
                                                          .contains(articles[
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
                                                  color: Color.fromARGB(
                                                      255, 22, 212, 79),
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
