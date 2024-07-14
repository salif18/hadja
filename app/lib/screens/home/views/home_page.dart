import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/api/category_api.dart';
import 'package:hadja_grish/components/drawer.dart';
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
        _listCategories.add((body["categories"] as List)
            .map((json) => CategoriesModel.fromJson(json))
            .toList());
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
        toolbarHeight: 80,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            drawerKey.currentState!.openDrawer();
          },
          icon: const Icon(
            Icons.sort,
            size: 28,
            color: Colors.white,
          ),
        ),
        title: Text(
          "La Hadja",
          style: GoogleFonts.allison(
            fontSize: 45,
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
                icon: const Icon(
                  FontAwesomeIcons.cartShopping,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  if (cartProvider.myCart.isNotEmpty) {
                    return Positioned(
                      left: 30,
                      bottom: 25,
                      child: Badge.count(
                        count: cartProvider.myCart.length,
                        backgroundColor: Colors.amber,
                        largeSize: 45 / 2,
                        textStyle: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
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
            icon: const Icon(
              FontAwesomeIcons.heart,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      backgroundColor: const Color(0xFF1D1A30),
      body: SingleChildScrollView(
        child: Column(
          children: [
           const Column(
              children: [
                MyHeaderWidget(),
                MySearchSectionWidget(),
              ],
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  MyCarouselWidget(),
                  MyChooseCategoryWidget(listCategories:_listCategories),
                  MyRecomadationWidget(),
                  MyProductListWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
