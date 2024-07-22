// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/models/articles_model.dart';
import 'package:hadja_grish/providers/cart_provider.dart';
import 'package:hadja_grish/providers/favorite_provider.dart';
import 'package:hadja_grish/screens/home/details/widgets/sliver_persistant_header.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class SingleProductVerSionSliver extends StatefulWidget {
  final ArticlesModel item;
  const SingleProductVerSionSliver({super.key, required this.item});

  @override
  State<SingleProductVerSionSliver> createState() =>
      _SingleProductVerSionSliverState();
}

class _SingleProductVerSionSliverState extends State<SingleProductVerSionSliver>
    with WidgetsBindingObserver {
  int qty = 1;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.resumed) {}
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    void Function(ArticlesModel, int) addToCart = cartProvider.addToCart;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: MySliverPersistentHeaderDelegate(
              maxHeight: 360,
              minHeight: 30,
              item: widget.item,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.grey[100],
              child: Column(
                children: [
                  _headerDescription(context),
                  _overProductImage(context),
                  _productDescription(context),
                  _diviser(context),
                  _actionsButtons(context, addToCart),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerDescription(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              widget.item.img,
              width: 80,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Consumer<FavoriteProvider>(
              builder: (context, favoriteProvider, child) {
                List<ArticlesModel> favorites = favoriteProvider.getFavorites;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.name,
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.item.price.toString(),
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: IconButton(
                        onPressed: () {
                          favoriteProvider.addMyFavorites(widget.item);
                        },
                        icon: favorites.firstWhereOrNull((item) => item
                                    .id
                                    == widget.item.id) ==
                                null
                            ? const Icon(
                                Icons.favorite_border,
                                size: 38,
                                color: Color(0xff2c3e50),
                              )
                            : const Icon(
                                Icons.favorite,
                                size: 38,
                                color: Colors.red,
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _overProductImage(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        scrollDirection: Axis.horizontal,
        itemCount: widget.item.galleries.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            width: 250,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                    widget.item.galleries[index].imgPath,
                fit: BoxFit.contain,
                )
            ),
          );
        },
      ),
    );
  }

  Widget _productDescription(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReadMoreText(
            widget.item.desc,
            trimLines: 2,
            colorClickableText: Colors.blue[400],
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Voir plus',
            trimExpandedText: ' réduire',
            style: TextStyle(
              color: const Color(0xFF1D1A30).withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _diviser(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Divider(
        height: 3,
        color: Colors.green[100],
        indent: 1,
      ),
    );
  }

  Widget _actionsButtons(
      BuildContext context, void Function(ArticlesModel, int) addToCart) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Quantité",
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        qty.toString(),
                        style: GoogleFonts.roboto(
                          fontSize: 60,
                        ),
                      ),
                      Text(
                        "${widget.item.price * qty}",
                        style: GoogleFonts.roboto(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1D1A30),
                        ),
                        onPressed: () {
                          setState(() {
                            qty = qty + 1;
                          });
                        },
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                      const SizedBox(width: 15),
                      if (qty > 1)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D1A30),
                          ),
                          onPressed: () {
                            setState(() {
                              qty = qty - 1;
                            });
                          },
                          child: const Icon(Icons.remove, color: Colors.white),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(300, 50),
                backgroundColor: const Color(0xFF1D1A30),
              ),
              onPressed: () {
                addToCart(widget.item, qty);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Article ajouté",
                    style: GoogleFonts.roboto(
                        fontSize: 16),
                  ),
                  // backgroundColor: const Color.fromARGB(255, 255, 35, 19),
                  duration: const Duration(seconds: 1),
                   backgroundColor: Colors.blueAccent,
                   action: SnackBarAction(
                    label: "",
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ));
              },
              icon: const Icon(Icons.add_shopping_cart,
                  color: Colors.white, size: 30),
              label: Text(
                "Ajouter au panier",
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
