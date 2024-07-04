import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/components/drawer.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      drawer: const DrawerWindow(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.1,
        toolbarHeight: 80,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              drawerKey.currentState!.openDrawer();
            },
            icon: const Icon(
              Icons.sort,
              size: 28,
              color: Colors.white,
            )),
        actions: [
          Stack(children: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartPage()));
                },
                icon: const Icon(
                  FontAwesomeIcons.cartShopping,
                  size: 28,
                  color: Colors.white,
                )),
                if(Provider.of<CartProvider>(context).myCart.isNotEmpty)
                Positioned(
                  left: 30,
                  bottom: 25,
                  child: Badge.count(
                    count: Provider.of<CartProvider>(context).myCart.length, 
                    backgroundColor: Colors.amber,
                    largeSize:45/2, 
                    textStyle: GoogleFonts.roboto(fontSize:18,fontWeight:FontWeight.bold,color:Colors.white),
                    ),
                )
          ]),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FavoritesPage()));
              },
              icon: const Icon(
                FontAwesomeIcons.heart,
                size: 28,
                color: Colors.white,
              )),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 5, 191, 100),
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
                      topRight: Radius.circular(20))),
              child: const Column(
                children: [
                  MyCarouselWidget(),
                  MyChooseCategoryWidget(),
                  MyRecomadationWidget(),
                  MyProductListWidget()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
