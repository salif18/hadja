import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadja_grish/constants/app_size.dart';
import 'package:hadja_grish/screens/admin/order_en_cours_page.dart';
import 'package:hadja_grish/screens/admin/order_livrer_page.dart';

class AdminOders extends StatefulWidget {
  const AdminOders({super.key});

  @override
  State<AdminOders> createState() => _AdminOdersState();
}

class _AdminOdersState extends State<AdminOders> {
 

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Commandes",
                style: GoogleFonts.roboto(
                    fontSize: AppSizes.fontMedium, fontWeight: FontWeight.w400)),
            centerTitle: true,
            toolbarHeight: 80,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: AppSizes.iconLarge)),
            bottom: TabBar(
                isScrollable: true,
                indicatorColor: const Color.fromARGB(255, 5, 191, 100),
                indicatorWeight: 4.3,
                labelPadding: const EdgeInsets.only(left: 50, right: 50),
                tabs: [
                  Tab(
                    child: Text("En attente",
                        style: GoogleFonts.roboto(
                            fontSize: AppSizes.fontMedium, fontWeight: FontWeight.w400)),
                  ),
                  Tab(
                    child: Text("Livré",
                        style: GoogleFonts.roboto(
                            fontSize: AppSizes.fontMedium, fontWeight: FontWeight.w400)),
                  ),
                ]),
          ),
          body:  const TabBarView(
            children: [
              Tab(child: OrderEnCours()),
              Tab(child: OrderLivrer()),
            ],
          )),
    );
  }
}
