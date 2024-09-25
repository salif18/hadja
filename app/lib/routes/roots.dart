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
          SearchPage(),
          MyArticlePage(),
          CartPage(),
          FavoritesPage()
        ][_currentIndex],
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    return SizedBox(
      height: 80,
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
        unselectedItemColor: const Color.fromARGB(255, 168, 168, 168),
        iconSize: AppSizes.iconLarge,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Accueil"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded), label: "Rechercher"),
          const BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.productHunt), label: "Produits"),
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
                        left: 8,
                        bottom: 6,
                        child: Badge.count(
                          count: provider.myCart.length,
                          largeSize: 35 / 2,
                          backgroundColor: Colors.red,
                          textStyle: GoogleFonts.roboto(
                            fontSize: 12,
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
  }
}
