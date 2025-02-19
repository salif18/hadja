import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/constants/app_size.dart';
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

class _FavoritesPageState extends State<FavoritesPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.resumed) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: MediaQuery.of(context).size.width * 50/360,
        centerTitle: true,
        title: Text(
          "Favoris",
          style: GoogleFonts.roboto(fontSize: MediaQuery.of(context).size.width * 16/360, fontWeight: FontWeight.w600),
        ),
      ),
      body: LayoutBuilder(
        builder: (context,constraints){
          return Consumer<FavoriteProvider>(
          builder: (context, favoriteProvider, child) {
            List<ArticlesModel> myFavorites = favoriteProvider.getFavorites;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Ma liste de souhaits",
                            style: GoogleFonts.roboto(
                                fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
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
                                          item: myFavorites[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child:
                                      MyCardFavorites(item: myFavorites[index],constraints: constraints,),
                                );
                              },
                            )
                          : EmptyFavorite(constraints: constraints,),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        },
      
      ),
    );
  }
}
