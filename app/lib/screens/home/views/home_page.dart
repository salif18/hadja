import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/category_api.dart';
import 'package:hadja_grish/components/drawer.dart';
import 'package:hadja_grish/constants/app_color.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/categorie_model.dart';
import 'package:hadja_grish/providers/cart_provider.dart';
import 'package:hadja_grish/screens/cart/views/cart_page.dart';
import 'package:hadja_grish/screens/favorites/views/favorites_page.dart';
import 'package:hadja_grish/screens/home/widgets/carrousel_widget.dart';
import 'package:hadja_grish/screens/home/widgets/categori_section_widget.dart';
import 'package:hadja_grish/screens/home/widgets/header_widget.dart';
import 'package:hadja_grish/screens/home/widgets/productlist_widget.dart';
import 'package:hadja_grish/screens/home/widgets/recomaded_widget.dart';
import 'package:hadja_grish/screens/home/widgets/search_section_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  ServicesApiCategory api = ServicesApiCategory();

  final StreamController<List<CategoriesModel>> _listCategories =
      StreamController<List<CategoriesModel>>();

  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  @override
  void dispose() {
    _listCategories.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getCategories();
  }

  Future<void> _getCategories() async {
    try {
      final res = await api.getCategories();
      final body = res.data;
      if (res.statusCode == 200) {

        List<CategoriesModel> converDataToModelCategorie = (body["categories"] as List)
            .map((json) => CategoriesModel.fromJson(json))
            .toList();
            converDataToModelCategorie.sort((a, b) => a.nameCategorie.compareTo(b.nameCategorie));
        _listCategories.add(converDataToModelCategorie);
      }
    } catch (e) {
      Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      drawer: const DrawerWindow(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.1,
        toolbarHeight: MediaQuery.of(context).size.width * 50/360,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            drawerKey.currentState!.openDrawer();
          },
          icon: Icon(
            Icons.sort,
            size:  MediaQuery.of(context).size.width * 24/360,
            color: Colors.white,
          ),
        ),
        title: Text(
          "LaHadja",
          style: GoogleFonts.allison(
            fontSize:  MediaQuery.of(context).size.width * 20/360,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartPage(),
                    ),
                  );
                },
                icon: Icon(
                  FontAwesomeIcons.cartShopping,
                  size: MediaQuery.of(context).size.width * 20/360,
                  color: Colors.white,
                ),
              ),
              Consumer<CartProvider>(
                builder: (context, provider, child) {
                  return FutureBuilder(
                      future: provider.loadCartFromLocalStorage(),
                      builder: (context, snaptshot) {
                        if (provider.myCart.isNotEmpty) {
                          return Positioned(
                            left:  MediaQuery.of(context).size.width * 30/360,
                            bottom:  MediaQuery.of(context).size.width * 25/360,
                            child: Badge.count(
                              count: provider.myCart.length,
                              backgroundColor: Colors.amber,
                              largeSize:  (MediaQuery.of(context).size.width * 40/360) / 2,
                              textStyle: GoogleFonts.roboto(
                                fontSize:  MediaQuery.of(context).size.width * 12/360,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      });
                },
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesPage(),
                ),
              );
            },
            icon: Icon(
              FontAwesomeIcons.heart,
              size: MediaQuery.of(context).size.width * 20/360,
              color: Colors.white,
            ),
          ),
           SizedBox(
            width:  MediaQuery.of(context).size.width * 15/360,
          )
        ],
      ),
      backgroundColor: AppColor.colorBackground,
      body: LayoutBuilder(
        builder: (context,constraints){
          return  SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  MyHeaderWidget(constraints:constraints),
                  MySearchSectionWidget(constraints:constraints),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                    topRight: Radius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                  ),
                ),
                child: Column(
                  children: [
                    MyCarouselWidget(constraints:constraints),
                    MyChooseCategoryWidget(listCategories: _listCategories,constraints:constraints),
                    MyRecomadationWidget(constraints:constraints),
                    MyProductListWidget(constraints:constraints),
                  ],
                ),
              ),
            ],
          ),
        );
        },
      ),
    );
  }
}
