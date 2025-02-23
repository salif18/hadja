import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/cart_item_model.dart';
import 'package:hadja_grish/providers/cart_provider.dart';
import 'package:hadja_grish/screens/articles/articles.dart';
import 'package:hadja_grish/screens/cart/widgets/address_livraison.dart';
import 'package:hadja_grish/screens/cart/widgets/card_cart.dart';
import 'package:hadja_grish/screens/cart/widgets/cart_empty.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with WidgetsBindingObserver {
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
          "Panier",
          style: GoogleFonts.roboto(fontSize: MediaQuery.of(context).size.width * 16/360, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyArticlePage()),
              );
            },
            icon: Icon(Icons.add, size:MediaQuery.of(context).size.width * 24/360, color: Color(0xFF1D1A30)),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 25/360),
        ],
      ),
      body: LayoutBuilder(
        builder: (context,constraints){
          return Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            List<CartItemModel> cart = cartProvider.myCart;
            return cart.isNotEmpty
                ? ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, int index) {
                      final item = cart[index];
                      return Dismissible(
                        key: Key(item.productId),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          cartProvider.removeToCart(item);
                        },
                        confirmDismiss: (direction) async {
                          return await _showAlertDelete(context,constraints);
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                          decoration: BoxDecoration(
                            color: Color(0xFF1D1A30),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                              bottomLeft: Radius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
                            ),
                          ),
                          child: Icon(Icons.delete_rounded,
                              size: constraints.maxWidth * AppSizes.converValueToadapter(context, 20), color: Colors.white),
                        ),
                        child: MyCard(item: item,constraints: constraints,),
                      );
                    },
                  )
                : EmptyCart(constraints: constraints,);
          },
        );
        },
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context,constraints){
          return Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            List<CartItemModel> cart = cartProvider.myCart;
            int total = cartProvider.total;
            int totalArticle =cartProvider.nombreArticles;
            return cart.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
                    decoration:  BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: Color.fromARGB(255, 246, 248, 246),
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),
                        topRight: Radius.circular(constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),
                      ),
                    ),
                    width: double.infinity,
                    height: constraints.maxWidth * AppSizes.converValueToadapter(context, 169),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Nombre d'articles",
                                style: GoogleFonts.roboto(
                                  fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF1D1A30),
                                ),
                              ),
                              Text(
                                "${totalArticle}",
                                style: GoogleFonts.roboto(
                                  fontSize:constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1D1A30),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: GoogleFonts.roboto(
                                  fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "$total FCFA",
                                style: GoogleFonts.roboto(
                                  fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1D1A30),
                              minimumSize: Size(constraints.maxWidth * AppSizes.converValueToadapter(context, 400), constraints.maxWidth * AppSizes.converValueToadapter(context, 40)),
                            ),
                            icon: Icon(
                              Icons.location_on,
                              size: constraints.maxWidth * AppSizes.converValueToadapter(context, 20),
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _showAddLocation(context,constraints);
                            },
                            label: Text(
                              "Adresse de livraison",
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
          },
        );
        },
      ),
    );
  }

  _showAlertDelete(BuildContext context,constraints) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width:constraints.maxWidth,
          height: constraints.maxWidth * AppSizes.converValueToadapter(context, 300),
          padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: constraints.maxWidth * AppSizes.converValueToadapter(context, 50),
                padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 10)),
                child: Text(
                  "Supprimer cet article de votre panier ?",
                  style: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12), color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(constraints.maxWidth * AppSizes.converValueToadapter(context, 8)),
                child: Divider(
                  height: 2,
                  color: Colors.grey,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  "Supprimer",
                  style: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12), color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  "Annuler",
                  style: GoogleFonts.roboto(fontSize: constraints.maxWidth * AppSizes.converValueToadapter(context, 12), color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddLocation(BuildContext context,constraints) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return  AddressLivraison(constraints: constraints,);
      },
    );
  }
}
