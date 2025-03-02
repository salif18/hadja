import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/models/user.dart';
import 'package:hadja_grish/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MyHeaderWidget extends StatefulWidget {
  final constraints;
  const MyHeaderWidget({super.key, required this.constraints});

  @override
  State<MyHeaderWidget> createState() => _MyHeaderState();
}

class _MyHeaderState extends State<MyHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
        child: Consumer<UserInfosProvider>(builder: (context, provider, child) {
          return FutureBuilder(
              future: provider.loadProfilFromLocalStorage(),
              builder: (context, snaptshot) {
                 ProfilModel? profil = snaptshot.data;
                return Container(
                  // height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 46),
                  padding:  EdgeInsets.symmetric(horizontal:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 15)),
                  decoration:  BoxDecoration(),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                         CircleAvatar(
                      radius: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 20),
                      backgroundImage: profil?.photo != null
                          ? NetworkImage(profil!.photo!)
                          : AssetImage("assets/images/profil1.jpg") as ImageProvider,
                      backgroundColor: Colors.transparent, // Couleur de fond pour éviter le noir
                    ),
                    SizedBox( width:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 10),),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Salut! ${profil?.name ?? "votre nom"}",
                                style: GoogleFonts.aBeeZee(
                                    fontWeight: FontWeight.w500,
                                    fontSize:widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                                    color: Colors.white)),
                            SizedBox(height: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 5)),
                            Text("Quel produit veux tu ?",
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.normal,
                                    fontSize: widget.constraints.maxWidth * AppSizes.converValueToadapter(context, 14),
                                    color: Colors.white))
                          ],
                        ),
                      ),
      
                    ],
                  ),
                );
              });
        }));
  }
}
