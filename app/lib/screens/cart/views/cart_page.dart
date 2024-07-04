import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    List<CartItemModel> cart = cartProvider.myCart;
    int total = cartProvider.total;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        title: Text(
          "Panier",
          style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyArticlePage()));
              },
              icon: const Icon(Icons.add, size: 28, color: Color(0xFF55AB60))),
          const SizedBox(
            width: 25,
          )
        ],
      ),
      body: SafeArea(
        child: cart.isNotEmpty
            ? ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, int index) {
                  final item = cart[index];
                  return Dismissible(
                    key: Key(item.productId),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        cartProvider.removeToCart(item);
                      });
                    },
                    confirmDismiss: (direction) async {
                      return await _showAlertDelete(context);
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: const BoxDecoration(
                        color: Color(0xFF55AB60),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: const Icon(Icons.delete_rounded,
                          size: 38, color: Colors.white),
                    ),
                    child: MyCard(item: item),
                  );
                },
              )
            : const EmptyCart(),
      ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color.fromARGB(255, 200, 255, 198),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              width: double.infinity,
              height: 200,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Nombre d'articles",
                          style: GoogleFonts.roboto(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF121212),
                          ),
                        ),
                        Text(
                          "${cart.length}",
                          style: GoogleFonts.roboto(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF121212),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: GoogleFonts.roboto(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "$total FCFA",
                          style: GoogleFonts.roboto(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF55AB60),
                        minimumSize: const Size(400, 50),
                      ),
                      icon: const Icon(
                        Icons.location_on,
                        size: 28,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _showAddLocation(context);
                      },
                      label: Text(
                        "Adresse de livraison",
                        style: GoogleFonts.roboto(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future _showAlertDelete(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Supprimer cet article de votre panier ?",
                  style: GoogleFonts.roboto(fontSize: 18, color: Colors.grey),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  height: 2,
                  color: Colors.grey,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  "Supprimer",
                  style: GoogleFonts.roboto(fontSize: 22, color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  "Annuler",
                  style: GoogleFonts.roboto(fontSize: 22, color: Colors.blue),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddLocation(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return const AddressLivraison();
      },
    );
  }
}
