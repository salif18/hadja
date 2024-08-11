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
  const MyProductListWidget({super.key});

  @override
  State<MyProductListWidget> createState() => _MyProductListWidgetState();
}

class _MyProductListWidgetState extends State<MyProductListWidget> {
  final StreamController<List<ArticlesModel>> _articlesData = StreamController();
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
// void didChangeDependencies(){
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
                      fontSize: AppSizes.fontLarge,color:AppColor.textColor ,fontWeight: FontWeight.w600),
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
                        fontSize: AppSizes.fontMedium,
                        fontWeight: FontWeight.w600,
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
                                    articles[index].img,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15,top: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(articles[index].name,
                                            style: GoogleFonts.roboto(
                                                fontSize: AppSizes.fontMedium,
                                                fontWeight: FontWeight.w600)),
                                        Text(
                                            "${articles[index].price.toString()} fcfa",
                                            style: GoogleFonts.roboto(
                                                fontSize: AppSizes.fontSmall,
                                                color: AppColor.accentColor)),
                                      ],
                                    ),
                                     IconButton(
                                          onPressed: () {
                                            favoriteProvider.addMyFavorites(
                                                articles[index]);
                                          },
                                          icon: favorites.firstWhereOrNull(
                                                      (item) => item.id
                                                          == articles[
                                                                  index]
                                                              .id) ==
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
