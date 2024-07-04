import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:hadja_grish/providers/favorite_provider.dart';
import 'package:hadja_grish/screens/favorites/widgets/card_favorite.dart';
import 'package:hadja_grish/screens/favorites/widgets/empty_favorite.dart';
import 'package:hadja_grish/screens/home/details/single_product_sliver.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final List<ArticlesModel> _data = ArticlesModel.data();

  

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);
    List<ArticlesModel> myFavorites = favoriteProvider.getFavorites;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        title: Text("Favoris",
            style:
                GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400)),
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
                    "Mes produits",
                    style: GoogleFonts.roboto(
                        fontSize: 24, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.only(top: 20),
                child: myFavorites.isNotEmpty
                    ? ListView.builder(
                        itemCount: myFavorites.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SingleProductVerSionSliver(
                                              item: _data[index])));
                            },
                            child: MyCardFavorites(item: _data[index]),
                          );
                        })
                    : const EmptyFavorite())
          ],
        ),
      )),
    );
  }
}
