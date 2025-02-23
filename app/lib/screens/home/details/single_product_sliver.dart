// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/constants/app_size.dart';
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
      body: LayoutBuilder(builder: (context,constraints){
        return CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: MySliverPersistentHeaderDelegate(
              maxHeight: constraints.maxWidth * AppSizes.converValueToadapter(context, 360),
              minHeight: constraints.maxWidth * AppSizes.converValueToadapter(context, 30),
              item: widget.item,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
               _headerDescription(context,constraints),
                  // _overProductImage(context),
                  _productDescription(context,constraints),
                  _diviser(context,constraints),
                  _actionsButtons(context, addToCart,constraints),
            ]),
           
          ),
        ],
      );
      })
    );
  }

  Widget _headerDescription(BuildContext context,constraints) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * AppSizes.converValueToadapter(context, 25)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
            ),
            child: Image.network(
              widget.item.img ?? "",
              width: constraints.maxWidth * AppSizes.converValueToadapter(context, 80),
            ),
          ),
          SizedBox(width: constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
          Expanded(
            child: Consumer<FavoriteProvider>(
              builder: (context, favoriteProvider, child) {
                List<ArticlesModel> favorites = favoriteProvider.getFavorites;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.name,
                              style: GoogleFonts.roboto(
                                fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "${widget.item.price.toString()} FCFA",
                              style: GoogleFonts.roboto(
                                fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ],
                        ),
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
                            ? Icon(
                                Icons.favorite_border,
                                size: constraints.maxWidth * AppSizes.converValueToadapter(context, 38),
                                color: Color(0xff2c3e50),
                              )
                            : Icon(
                                Icons.favorite,
                                size: constraints.maxWidth * AppSizes.converValueToadapter(context, 38),
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

  // Widget _overProductImage(BuildContext context) {
  //   return Container(
  //     height: 200,
  //     padding: const EdgeInsets.symmetric(vertical: 20),
  //     child: ListView.builder(
  //       padding: const EdgeInsets.symmetric(horizontal: 25),
  //       scrollDirection: Axis.horizontal,
  //       itemCount: widget.item.galleries!.length,
  //       itemBuilder: (context, index) {
  //         return Container(
  //           margin: const EdgeInsets.all(8),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           width: 250,
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(20),
  //             child: Image.network(
  //                   widget.item.galleries![index].imgPath ?? "",
  //               fit: BoxFit.contain,
  //               )
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _productDescription(BuildContext context,constraints) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * AppSizes.converValueToadapter(context, 25),vertical: constraints.maxWidth * AppSizes.converValueToadapter(context, 25)),
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
              fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
              color: const Color(0xFF1D1A30).withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _diviser(BuildContext context,constraints) {
    return Padding(
      padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
      child: Divider(
        height: 3,
        color: Colors.green[100],
        indent: 1,
      ),
    );
  }

  Widget _actionsButtons(
      BuildContext context, void Function(ArticlesModel, int) addToCart,constraints) {
    return Container(
      padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 25)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Quantité",
                        style: GoogleFonts.roboto(
                          fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        qty.toString(),
                        style: GoogleFonts.roboto(
                          fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 60),
                        ),
                      ),
                      Text(
                        "${widget.item.price * qty} Fcfa",
                        style: GoogleFonts.roboto(
                          fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
                Padding(
                  padding: EdgeInsets.all(1),
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(constraints.maxWidth * AppSizes.converValueToadapter(context, 40), constraints.maxWidth * AppSizes.converValueToadapter(context, 40)),
                          backgroundColor: const Color(0xFF1D1A30),
                        ),
                        onPressed: () {
                          setState(() {
                            qty = qty + 1;
                          });
                        },
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                     SizedBox(width: constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
                      if (qty > 1)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(constraints.maxWidth * AppSizes.converValueToadapter(context, 40), constraints.maxWidth * AppSizes.converValueToadapter(context, 40)),
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
            padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(constraints.maxWidth * AppSizes.converValueToadapter(context, 300), constraints.maxWidth * AppSizes.converValueToadapter(context, 40)),
                backgroundColor: Colors.orangeAccent,
              ),
              onPressed: () {
                addToCart(widget.item, qty);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Article ajouté",
                    style: GoogleFonts.roboto(
                        fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context, 12)),
                  ),
                  // backgroundColor: const Color.fromARGB(255, 255, 35, 19),
                  duration: const Duration(seconds: 1),
                   backgroundColor: Colors.blueAccent,
                ));
              },
              icon: Icon(Icons.add_shopping_cart,
                  color: Colors.white, size: constraints.maxWidth * AppSizes.converValueToadapter(context, 30)),
              label: Text(
                "Ajouter au panier",
                style: GoogleFonts.roboto(
                  fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
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

