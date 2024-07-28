import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/models/user.dart';
import 'package:hadja_grish/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MyHeaderWidget extends StatefulWidget {
  const MyHeaderWidget({super.key});

  @override
  State<MyHeaderWidget> createState() => _MyHeaderState();
}

class _MyHeaderState extends State<MyHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Consumer<UserInfosProvider>(builder: (context, provider, child) {
          return FutureBuilder(
              future: provider.loadProfilFromLocalStorage(),
              builder: (context, snaptshot) {
                 ProfilModel? profil = snaptshot.data;
                return Container(
                  height: 100,
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Salut! ${profil?.name ?? "votre nom"}",
                              style: GoogleFonts.aBeeZee(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25,
                                  color: Colors.white)),
                          const SizedBox(height: 5),
                          Text("Quel produit veux tu ?",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  color: Colors.grey[100]))
                        ],
                      ),
                      CircleAvatar(
                        radius: 40,
                        child: Image(
                          image: AssetImage(
                              profil?.photo ?? "assets/images/profil.jpeg"),
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                );
              });
        }));
  }
}
