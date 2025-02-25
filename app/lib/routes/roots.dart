import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/providers/cart_provider.dart';
import 'package:hadja_grish/screens/articles/articles.dart';
import 'package:hadja_grish/screens/cart/views/cart_page.dart';
import 'package:hadja_grish/screens/favorites/views/favorites_page.dart';
import 'package:hadja_grish/screens/home/views/home_page.dart';
import 'package:hadja_grish/screens/search/views/search_page.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MyRoots extends StatefulWidget {
  const MyRoots({super.key});

  @override
  State<MyRoots> createState() => _MyRootsState();
}

class _MyRootsState extends State<MyRoots> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:<Widget>[
          HomePage(),
          MyArticlePage(),
          SearchPage(),
          CartPage(),
          FavoritesPage()
        ][_currentIndex],
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    return LayoutBuilder(
      builder: (context,constraints){
        return SizedBox(
        height: constraints.maxWidth * AppSizes.converValueToadapter(context, 60),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          elevation: 20,
          selectedItemColor: const Color(0xFF1D1A30),
          unselectedItemColor: const Color.fromARGB(255, 209, 209, 209),
          iconSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 30),
        selectedLabelStyle: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12)),
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Accueil"),
                 BottomNavigationBarItem(
                icon: Icon(MdiIcons.textSearchVariant), label: "Produits"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded), label: "Rechercher"),
           
            BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (context, provider, child) {
                  return FutureBuilder(
                    future: provider.loadCartFromLocalStorage(), 
                    builder: (context, snaptshot){
                      return Stack(
                    children: [
                      const Icon(Icons.shopping_cart_outlined),
                      if (provider.myCart.isNotEmpty)
                        Positioned(
                          left: constraints.maxWidth * AppSizes.converValueToadapter(context, 10),
                          bottom: constraints.maxWidth * AppSizes.converValueToadapter(context, 20),
                          child: Badge.count(
                            count: provider.nombreArticles,
                            largeSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 20) / 2,
                            backgroundColor: Colors.red,
                            textStyle: GoogleFonts.roboto(
                              fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 8),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  );
                    }
                    );
                },
              ),
              label: "Panier",
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_rounded), label: "Favoris"),
          ],
        ),
      );
      },
    );
  }
}
