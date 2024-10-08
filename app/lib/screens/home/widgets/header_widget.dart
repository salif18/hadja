import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/constants/app_size.dart';
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
                  height: 110,
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
                                  fontSize: AppSizes.fontMedium,
                                  color: Colors.white)),
                          const SizedBox(height: 5),
                          Text("Quel produit veux tu ?",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.normal,
                                  fontSize: AppSizes.fontMedium,
                                  color: Colors.grey[100]))
                        ],
                      ),
                      CircleAvatar(
                      radius: 30,
                      backgroundImage: profil?.photo != null
                          ? NetworkImage(profil!.photo!)
                          : AssetImage("assets/images/profil1.jpg") as ImageProvider,
                      backgroundColor: Colors.transparent, // Couleur de fond pour éviter le noir
                    ),
                    ],
                  ),
                );
              });
        }));
  }
}
