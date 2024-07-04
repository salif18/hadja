import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool isAdmin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomePage(),
          SearchPage(),
          MyArticlePage(),
          CartPage(),
          FavoritesPage()
        ],
      ),
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
          selectedItemColor: const Color.fromARGB(255, 5, 191, 100),
          unselectedItemColor: Colors.black,
          iconSize: 30,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "acceuil"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded), label: "rechercher"),
            const BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.productHunt), label: "produits"),
            BottomNavigationBarItem(
                icon: Stack(children: [
                  const Icon(Icons.shopping_cart_outlined),
                  if(Provider.of<CartProvider>(context).myCart.isNotEmpty)
                  Positioned(
                    left: 15,
                    bottom: 15,
                    child: Badge.count(
                      count: Provider.of<CartProvider>(context).myCart.length,
                      backgroundColor: Colors.red,
                      textStyle: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )
                ]),
                label: "panier"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_rounded), label: "favoris"),
          ]),
    );
  }
}
