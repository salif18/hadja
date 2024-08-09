import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/screens/articles/articles.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Panier vide",
              style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Icon(Icons.shopping_cart_outlined, size: 60),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Ajouter des articles dans votre panier",
                style: GoogleFonts.roboto(
                    fontSize: 14, color: const Color(0xFF1D1A30))),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
                "Regrouper ici les articles qui vous interressent et envoyer-les a l'entreprise",
                style: GoogleFonts.roboto(fontSize:14, color: Colors.grey)),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyArticlePage()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D1A30),
                    minimumSize: const Size(400, 50)),
                child: Text("Voir les articles",
                    style:
                        GoogleFonts.roboto(fontSize: 14, color: Colors.white))),
          )
        ],
      ),
    );
  }
}
